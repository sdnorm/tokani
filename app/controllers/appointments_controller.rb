class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :interpreter_requests, :update_status, :schedule, :time_finish, :update_time_finish, :cancel_appointment]

  before_action :authenticate_user!
  before_action :set_account
  before_action :set_appointments, only: [:index, :fetch_appointments]
  # before_action :appointments_per_logged_in_account, only: [:index]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /appointments
  def index
    @appointments = AppointmentsFilteringService.new(current_user, filtering_params, @appointments).fetch_appointments
    @pagy, @appointments = pagy(@appointments.sort_by_params(params[:sort], sort_direction))

    @statuses = ["all", "scheduled", "finished"]
    @customer_names = @appointments.map(&:customer).pluck(:name).uniq
    @modalities = Appointment.modalities.keys

    @scheduled_appts_count = @appointments.by_appointment_specific_status("scheduled").count
    @finished_appts_count = @appointments.by_appointment_specific_status("finished").count
  end

  def schedule
    # available interpreters are: Interpreters that are limited by: language, availability, modality, time off
    modality = @appointment.modality
    language_id = @appointment.language_id
    agency_id = @appointment.agency_id

    time_zone_to_use = if @appointment.time_zone.nil?
      Account.find(agency_id).agency_detail.time_zone
    else
      @appointment.time_zone
    end

    my_range = @appointment.to_tsrange
    duration_in_seconds = @appointment.duration.to_i * 60
    start_day = nil
    updated_time = nil
    tod_start = nil
    tod_end = nil

    # By language
    @interpreters = Account.find(agency_id).interpreters.joins(:interpreter_languages).where("interpreter_languages.language_id = :language_id", {language_id: language_id})
    # @interpreters = Account.find(agency_id).interpreters

    # By availability
    Time.use_zone(time_zone_to_use) do
      start_day = @appointment.start_time.wday
      updated_time = @appointment.start_time
    end

    @avail_interpreters = @interpreters.joins(:availabilities).where(availabilities: {wday: start_day, modality.to_sym => true})
    or_call = nil

    # Check all the agency available timezones appointment times in relation to those zone, and then check interpreter availabilities
    Agency.available_timezones.each do |tz|
      Time.use_zone(tz) do
        # appointments getting stored as UTC but when offset is applied based on timezones - messes up result of the appointment time in the
        # zone it was taken in.  For example, appointment intook for 11am on Thurday April 27 is stored as Thu, 27 Apr 2023 11:00:00.000000000 UTC +00:00,
        # with no offset to reflect the timezone it was intook in (for this example it is pacific).  So when we loop through on pacific time zone I am
        # not applying pacific offset....timezones and how appointment date/time is getting set in DB needs to get looked at!
        new_time = if tz.name == time_zone_to_use
          @appointment.start_time
        else
          Time.zone.at(@appointment.start_time)
        end
        tod_start = new_time.seconds_since_midnight
        tod_end = tod_start + duration_in_seconds

        or_call = if or_call.nil?
          User.where("(availabilities.time_zone = :timezone AND availabilities.start_seconds <= :start_seconds AND availabilities.end_seconds >= :end_seconds)", {timezone: tz.name, start_seconds: tod_start, end_seconds: tod_end})
        else
          or_call.or(User.where("(availabilities.time_zone = :timezone AND availabilities.start_seconds <= :start_seconds AND availabilities.end_seconds >= :end_seconds)", {timezone: tz.name, start_seconds: tod_start, end_seconds: tod_end}))
        end
      end
    end

    @avail_interpreters = @avail_interpreters.and(or_call)

    # make it distinct
    @avail_interpreters_ids = @avail_interpreters.distinct

    avail_interpreters_ids = @avail_interpreters.map(&:id)
    # check time off
    @interpreters_off = User.joins(:time_offs).where(id: avail_interpreters_ids).where("time_offs.date_range && tsrange(:st, :et)", {st: my_range.first, et: my_range.last})

    @avail_interpreters -= @interpreters_off
  end

  def interpreter_requests
    @requested_interpreters = @appointment.requested_interpreters
    @assigned_interpreter = @appointment.assigned_interpreter
    @language_id = @appointment.language.id
    @specialties = Specialty.active.order("name ASC")

    # this is to set the radio button correctly on interpreter_request fields
    @general_int_requested = @appointment.requested_interpreters.empty?
    @assigned_interpreter = @appointment.assigned_interpreter.nil?
    @specific_int_requested = (!@general_int_requested && !@assigned_interpreter) ? true : false
  end

  def search_interpreters_path
    @searched_for_interpreters = interpreters.search_by_full_name(params[:q]).order("first_name ASC").limit(10)
    render partial: "appointments/search_for_interpreters"
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    scoped_statuses = AppointmentPolicy::AppointmentStatusesScope.new(current_account_user, AppointmentStatus).resolve

    # Fetched from AppointmentWorkflow
    @appointment_statuses = @appointment.allowed_actions(scoped_statuses)
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new

    if params[:customer_id].blank? && !requestor_logged_in?
      @account_customers = current_account.customers
    else
      setup_appointment_vars
    end
  end

  # GET /appointments/1/edit
  def edit
    @account_customers = current_account.customers
    @customer = @appointment.customer
    @sites = @customer.sites.order("name ASC")
    if @appointment.site.present?
      # @departments = @appointment.site.departments
      @departments = Department.where(site_id: @sites.pluck(:id)).order("name ASC")
    end

    @departments ||= []

    @languages = current_account.account_languages

    # @interpreters = current_account.interpreters
    requestor_ids = @customer.requestor_details.pluck(:requestor_id)
    @requestors = User.where(id: requestor_ids)

    @providers = @customer.providers
    @recipients = @customer.recipients

    @requested_interpreters = @appointment.offered_interpreters
    @specific_int_requested = true if @appointment.interpreter_type == "specific"
  end

  def time_finish
    setup_time_finish_vars
  end

  def update_time_finish
    @appointment.combine_finish_date_and_time(appointment_time_finish_params[:submitted_finish_date], appointment_time_finish_params[:submitted_finish_time], current_user)

    if @appointment.finish_time < @appointment.start_time
      setup_time_finish_vars
      flash[:alert] = "There was a problem time finishing the appointment: Finish time must be later than the start time."
      return render :time_finish
    end

    if @appointment.update(appointment_time_finish_params)
      AppointmentStatus.create!(appointment: @appointment, name: AppointmentStatus.names["finished"], user: current_user)
      redirect_to(appointment_path(@appointment), notice: "Appointment successfully time finished.")
    else
      setup_time_finish_vars
      errors = @appointment.errors.full_messages.join("; ")
      flash[:alert] = "There was a problem time finishing the appointment: #{errors}"
      render :time_finish
    end
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    # NW - have to include all these variables for form to re-render correctly if errors are thrown on create
    if agency_logged_in?
      @account_customers = current_account.customers
      @languages = current_account.account_languages
      @appointment.agency_id = @account.id
    else
      agency_id = AgencyCustomer.find_by(customer_id: current_account.id).agency_id
      @languages = Language.where(account_id: agency_id)
      @appointment.agency_id = agency_id
    end
    @customer = Customer.find(appointment_params[:customer_id])
    @sites = @customer.sites.order("name ASC")

    department_list = Department.where(site_id: @sites).order("name ASC")
    @departments = [["None", ""]]
    @departments += department_list.map { |dept| [dept.name, dept.id] } if department_list.present?

    requestor_ids = @customer.requestor_details.pluck(:requestor_id)
    @requestors = User.where(id: requestor_ids)
    @providers = @customer.providers
    @recipients = @customer.recipients
    @general_int_requested = true
    @specific_int_requested = !@general_int_requested

    # Uncomment to authorize with Pundit
    # authorize @appointment

    # @appointment.agency_id = @account.id
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
        # NW - commenting this out because it preventa validation errors from being shown to user
        # setup_appointment_vars
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /appointments/1 or /appointments/1.json
  def update
    int_type_requested = appointment_params[:interpreter_type]
    if int_type_requested == "specific"
      @appointment.gender_req = nil
      @appointment.viewable_by = nil
    end

    respond_to do |format|
      if @appointment.update(appointment_params)
        if appointment_params[:status] == "scheduled"
          AppointmentStatus.create(name: "scheduled", appointment_id: @appointment.id, user_id: current_user.id)
        end
        format.html { redirect_to @appointment, notice: "Appointment was successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy
    respond_to do |format|
      format.html { redirect_to appointments_url, status: :see_other, notice: "Appointment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_status
    status = params[:status]

    authorize @appointment, :"#{status}?"

    respond_to do |format|
      if @appointment.send(:"#{status}!")
        format.html { redirect_to @appointment, notice: "Appointment status successfully updated." }
        format.json { render :show, status: :ok, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel_appointment
    authorize @appointment

    respond_to do |format|
      if @appointment.cancel!
        format.html { redirect_to @appointment, notice: "Appointment was successfully cancelled." }
        format.json { render :show, status: :created, location: @appointment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @appointment = Appointment.find(params[:id])

  # Uncomment to authorize with Pundit
  # authorize @appointment
  rescue ActiveRecord::RecordNotFound
    redirect_to appointments_path
  end

  def set_account
    @account = current_account
  end

  def set_appointments
    # Scope appointments for current_account
    @appointments = AppointmentPolicy::AccountScope.new(current_account, Appointment).resolve
  end

  def setup_appointment_vars
    if agency_logged_in?
      @account_customers = current_account.customers
      @interpreters = current_account.interpreters
      @languages = current_account.account_languages
    else
      agency_id = AgencyCustomer.find_by(customer_id: current_account.id).agency_id
      @interpreters = Account.find(agency_id).interpreters
      @languages = Language.where(account_id: agency_id)
    end

    @customer = requestor_logged_in? ? Customer.find(current_account.id) : Customer.find(params[:customer_id])

    @sites = @customer.sites.order("name ASC")

    department_list = Department.where(site_id: @sites).order("name ASC")
    @departments = [["None", ""]]
    @departments += department_list.map { |dept| [dept.name, dept.id] } if department_list.present?

    requestor_ids = @customer.requestor_details.pluck(:requestor_id)
    @requestors = User.where(id: requestor_ids)
    @providers = @customer.providers
    @recipients = @customer.recipients
    @general_int_requested = true
    @specific_int_requested = !@general_int_requested
  end

  def setup_time_finish_vars
    @docs_list = @appointment.documents.map { |doc| {name: doc.filename.to_s, size: doc.byte_size, url: url_for(doc), signed_id: doc.signed_id} }
    @docs_list_json = @docs_list.to_json
  end

  def filtering_params
    params.permit(
      :status,
      :start_date,
      :end_date,
      :customer_name,
      :modality_in_person,
      :modality_phone,
      :modality_video,
      :search_query,
      sort_by: [:date, :customer]
    )
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(
      :customer_id,
      :interpreter_id,
      :ref_number,
      :start_time,
      :finish_time,
      :duration,
      :modality,
      :sub_type,
      :gender_req,
      :admin_notes,
      :notes,
      :details,
      :status,
      :interpreter_type,
      :viewable_by,
      :billing_notes,
      :canceled_by,
      :cancel_reason_code,
      :lock_version,
      :time_zone,
      :confirmation_date,
      :confirmation_phone,
      :confirmation_notes,
      :home_health_appointment,
      :site_id,
      :department_id,
      :provider_id,
      :recipient_id,
      :language_id,
      :requestor_id,
      :creator_id,
      :assigned_interpreter,
      :video_link,
      interpreter_req_ids: []
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:appointment).permit(policy(@appointment).permitted_attributes)
  end

  def appointment_time_finish_params
    params.require(:appointment).permit(
      :submitted_finish_date,
      :submitted_finish_time,
      :billing_notes,
      documents: []
    )
  end
end
