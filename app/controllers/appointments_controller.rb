class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :interpreter_requests, :update_status]

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
    @pagy, @appointments = pagy(@appointments)

    @statuses = ["all", "scheduled", "finished"]
    @customer_names = @appointments.map(&:customer).pluck(:name).uniq
    @modalities = Appointment.modalities.keys

    @scheduled_appts_count = @appointments.by_appointment_specific_status("scheduled").count
    @finished_appts_count = @appointments.by_appointment_specific_status("finished").count
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
    # @appt_status = AppointmentStatus.where(appointment_id: @appointment.id).order("updated_at DESC")
    @appt_statuses = customer_logged_in? ?
      AppointmentStatus.names.slice("cancelled") :
      AppointmentStatus.names.slice("opened", "finished")
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

    @interpreters = current_account.interpreters
    requestor_ids = @customer.requestor_details.pluck(:requestor_id)
    @requestors = User.where(id: requestor_ids)

    @providers = @customer.providers
    @recipients = @customer.recipients

    @requested_interpreters = @appointment.offered_interpreters
    @general_int_requested = @appointment.requested_interpreters.empty?
    @assigned_interpreter = @appointment.assigned_interpreter.nil?
    @specific_int_requested = (!@general_int_requested && !@assigned_interpreter) ? true : false
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    # @appointment.customer = current_account if requestor_logged_in?

    # NW - have to include all these variables for form to re-render correctly if errors are thrown on create
    # @account_customers = current_account.customers
    if agency_logged_in?
      @account_customers = current_account.customers
      @interpreters = current_account.interpreters
      @languages = current_account.account_languages
    else
      agency_id = AgencyCustomer.find_by(customer_id: current_account.id).agency_id
      @interpreters = Account.find(agency_id).interpreters
      @languages = Language.where(account_id: agency_id)
    end
    @customer = Customer.find(appointment_params[:customer_id])
    @sites = @customer.sites.order("name ASC")

    department_list = Department.where(site_id: @sites).order("name ASC")
    @departments = [["None", ""]]
    @departments += department_list.map { |dept| [dept.name, dept.id] } if department_list.present?
    # @languages = current_account.account_languages

    # @interpreters = current_account.interpreters
    requestor_ids = @customer.requestor_details.pluck(:requestor_id)
    @requestors = User.where(id: requestor_ids)
    @providers = @customer.providers
    @recipients = @customer.recipients
    @general_int_requested = true
    @specific_int_requested = !@general_int_requested

    if agency_logged_in?
      @account_customers = current_account.customers
      @interpreters = current_account.interpreters
      @languages = current_account.account_languages
    else
      agency_id = AgencyCustomer.find_by(customer_id: current_account.id).agency_id
      @interpreters = Account.find(agency_id).interpreters
      @languages = Language.where(account_id: agency_id)
    end
    # Uncomment to authorize with Pundit
    # authorize @appointment

    @appointment.agency_id = @account.id
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
    int_type_requested = params[:interpreter_reqs]

    if int_type_requested == "specific"
      @appointment.gender_req = nil
      @appointment.interpreter_type = "none"
    end
    respond_to do |format|
      if @appointment.update(appointment_params)
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
    @appt_status = @appointment.appointment_statuses.new(
      name: params.dig(:appointment, :status),
      user_id: current_account.owner_id
    )

    respond_to do |format|
      @appt_status.save ?
        format.json { render json: {status: @appointment.status} } :
        format.json { render json: {error: "Something went wrong while updating appointment's status!"} }
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
      interpreter_req_ids: []
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:appointment).permit(policy(@appointment).permitted_attributes)
  end
end
