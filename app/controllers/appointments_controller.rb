class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :interpreter_requests]

  before_action :authenticate_user!
  before_action :set_account

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /appointments
  def index
    @pagy, @appointments = pagy(@account.appointments.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @appointments
  end

  def interpreter_requests
    @requested_interpreters = @appointment.requested_interpreters
    @language_id = @appointment.language.id
    @specialties = Specialty.active.order("name ASC")

    # this is to set the radio button correctly on interpreter_request fields
    @general_int_requested = @appointment.requested_interpreters.empty?
    @specific_int_requested = !@general_int_requested
  end

  # GET /appointments/1 or /appointments/1.json
  def show
    # @appt_status = AppointmentStatus.where(appointment_id: @appointment.id).order("updated_at DESC")
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new

    if params[:customer_id].blank?
      @account_customers = current_account.customers
      # @agency_customers = AgencyCustomer.all.order('name ASC')
      return
    end

    @account_customers = current_account.customers
    @customer = Customer.find(params[:customer_id])
    @sites = @customer.sites.order("name ASC")
    @departments = Department.where(site_id: @sites.pluck(:id)).order("name ASC")
    @departments || []

    @languages = current_account.account_languages

    @interpreters = current_account.interpreters
    requestor_ids = @customer.requestor_details.pluck(:requestor_id)
    @requestors = User.where(id: requestor_ids)
    @providers = @customer.providers
    @recipients = @customer.recipients
    @general_int_requested = true
    @specific_int_requested = !@general_int_requested
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
    @specific_int_requested = !@general_int_requested
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    # Uncomment to authorize with Pundit
    # authorize @appointment

    @appointment.agency_id = @account.id
    respond_to do |format|
      if @appointment.save
        format.html { redirect_to @appointment, notice: "Appointment was successfully created." }
        format.json { render :show, status: :created, location: @appointment }
      else
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
      interpreter_req_ids: []
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:appointment).permit(policy(@appointment).permitted_attributes)
  end
end
