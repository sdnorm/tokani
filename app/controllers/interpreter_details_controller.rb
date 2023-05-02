class InterpreterDetailsController < ApplicationController
  include CurrentHelper
  before_action :authenticate_user!
  before_action :authenticate_interpreter_user!
  before_action :set_interpreter_detail, only: [:show, :edit, :update, :destroy]
  before_action :set_notification_setting, only: [:edit, :new, :show, :create]
  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /interpreter_details/1 or /interpreter_details/1.json
  def show
    @interpreter_detail_fields = %w[
      interpreter_type address city dob drivers_license emergency_contact_name
      emergency_contact_phone gender interpreter_type primary_phone ssn start_date state zip
      languages time_zone
    ]
  end

  # GET /interpreter_details/new
  def new
    @interpreter_detail = InterpreterDetail.new

    # Uncomment to authorize with Pundit
    authorize @interpreter_detail
  end

  # GET /interpreter_details/1/edit
  def edit
    authorize @interpreter_detail

    @languages_json = current_account.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @interpreter_languages_json = current_user.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
  end

  # POST /interpreter_details or /interpreter_details.json
  def create
    @interpreter_detail = InterpreterDetail.new(interpreter_detail_params)

    # Uncomment to authorize with Pundit
    authorize @interpreter_detail

    respond_to do |format|
      if @interpreter_detail.save
        format.html { redirect_to @interpreter_detail, notice: "Interpreter detail was successfully created." }
        format.json { render :show, status: :created, location: @interpreter_detail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @interpreter_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interpreter_details/1 or /interpreter_details/1.json
  def update
    authorize @interpreter_detail

    respond_to do |format|
      if @interpreter_detail.update(interpreter_detail_params)
        format.html { redirect_to @interpreter_detail, notice: "Interpreter detail was successfully updated." }
        format.json { render :show, status: :ok, location: @interpreter_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @interpreter_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interpreter_details/1 or /interpreter_details/1.json
  def destroy
    authorize @interpreter_detail

    @interpreter_detail.destroy
    respond_to do |format|
      format.html { redirect_to interpreter_details_url, status: :see_other, notice: "Interpreter detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_languages
    # authorize @interpreter_detail

    @interpreter_detail = current_user&.interpreter_detail

    respond_to do |format|
      if current_user.update(language_params)
        format.html { redirect_to @interpreter_detail, notice: "Languages were successfully updated." }
        format.json { render :show, status: :ok, location: @interpreter_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @interpreter_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_interpreter_detail
    # Make sure the details requested belong to the current user
    @interpreter_detail = current_user&.interpreter_detail

    if @interpreter_detail&.id != (params[:id] || 0).to_i
      redirect_to "/"
    end

    # Uncomment to authorize with Pundit
    # authorize @interpreter_detail
  rescue ActiveRecord::RecordNotFound
    redirect_to interpreter_details_path
  end

  # Only allow a list of trusted parameters through.
  def interpreter_detail_params
    params.require(:interpreter_detail).permit(:interpreter_type, :gender, :primary_phone, :interpreter_id, :ssn, :dob, :address,
      :city, :state, :zip, :start_date, :drivers_license, :emergency_contact_name, :emergency_contact_phone, :time_zone)

    # Uncomment to use Pundit permitted attributes
    # params.require(:interpreter_detail).permit(policy(@interpreter_detail).permitted_attributes)
  end

  def language_params
    params.require(:user).permit(language_ids: [])
  end

  def authenticate_interpreter_user!
    redirect_to "/", alert: "Unauthorized access for non-interpreter users." unless current_account_user.interpreter?
  end

  def set_notification_setting
    @notification_setting ||= current_user&.notification_setting
    @notification_setting ||= NotificationSetting.new
  end
end
