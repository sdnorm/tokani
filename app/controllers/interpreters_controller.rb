class InterpretersController < ApplicationController
  include CurrentHelper

  before_action :authenticate_user!
  before_action :set_interpreter, only: [:show, :edit, :update, :destroy]
  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /interpreters
  def index
    @pagy, @interpreters = pagy(User.where(id: current_account.account_users.interpreter.pluck(:user_id)).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @interpreters
  end

  def search
    name_query = params[:q]
    name_query = "%#{name_query}%"

    # we need to tie language and modality into this search criteria eventually
    # language_id = params[:language_id]
    # modality = params[:modality]

    # if name_query.blank? || language_id.blank?
    if name_query.blank?
      @interpreters = []
    else
      # @interpreters = Interpreter.joins(:interpreter_languages).where('interpreter_languages.language_id = :language_id', {language_id: language_id})
      @interpreters = current_account.interpreters
      @interpreters = @interpreters.where("last_name ilike ? or first_name ilike ?", name_query, name_query)
    end

    respond_to do |format|
      format.html { render partial: "search_results" }
    end
  end

  def new
    @interpreter = User.new
    @interpreter.build_interpreter_detail
  end

  def show
  end

  def create
    @interpreter = User.new(interpreter_params)
    @interpreter.terms_of_service = true
    @interpreter.skip_default_account = true
    respond_to do |format|
      if @interpreter.save
        AccountUser.create!(account_id: current_account.id, user_id: @interpreter.id, roles: {"interpreter" => true})
        format.html { redirect_to interpreter_path(@interpreter), notice: "Interpreter was successfully created." }
        format.json { render :show, status: :created, location: @interpreter }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @interpreter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interpreters/1 or /interpreters/1.json
  def update
    respond_to do |format|
      if @interpreter.update(interpreter_params)
        format.html { redirect_to interpreter_path(@interpreter), notice: "Interpreter was successfully updated." }
        format.json { render :show, status: :ok, location: @interpreter }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @interpreter.errors, status: :unprocessable_entity }
      end
    end
  end

  def my_scheduled
    @status = "scheduled"
    @service = InterpreterAppointmentsService.new(current_user, {status: @status, display_range: "today"})
    @appointments = @service.fetch_appointments
  end

  def my_scheduled_details
  end

  def my_assigned
    @status = "offered"
    @service = InterpreterAppointmentsService.new(current_user, {status: @status, display_range: "today"})
    @appointments = @service.fetch_appointments
  end

  def fetch_appointments
    @service = InterpreterAppointmentsService.new(current_user, appointment_params)
    @appointments = @service.fetch_appointments
    render layout: nil
  end

  def my_assigned_details
  end

  def profile
  end

  def profile_notifications_edit
  end

  def profile_personal_edit
  end

  def profile_security_edit
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_interpreter
    int = current_account.account_users.interpreter.find_by(user_id: params[:id])
    int_id = int.user_id
    @interpreter = User.find_by(id: int_id)
  rescue ActiveRecord::RecordNotFound
    redirect_to interpreters_path
  end

  # Only allow a list of trusted parameters through.
  def interpreter_params
    params.require(:user).permit(
      :email,
      :password,
      :first_name,
      :last_name,
      :terms_of_service,
      interpreter_detail_attributes: [
        :id,
        :gender,
        :interpreter_type,
        :primary_phone,
        :email,
        :ssn,
        :dob,
        :start_date,
        :drivers_license,
        :emergency_contact_name,
        :emergency_contact_phone,
        :address,
        :city,
        :state,
        :zip
      ]
    )
  end

  def appointment_params
    params.permit(:status, :display_range, :start_date, :end_date, :modality_in_person, :modality_phone, :modality_video)
  end
end
