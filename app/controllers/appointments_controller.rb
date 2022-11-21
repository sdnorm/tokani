class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /appointments
  def index
    @pagy, @appointments = pagy(Appointment.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @appointments
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new

    # Uncomment to authorize with Pundit
    # authorize @appointment
  end

  # GET /appointments/1/edit
  def edit
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)

    # Uncomment to authorize with Pundit
    # authorize @appointment

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

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.require(:appointment).permit(:ref_number, :start_time, :finish_time, :duration, :modality, :sub_type, :gender_req, :admin_notes, :notes, :details, :status, :interpreter_type, :billing_notes, :canceled_by, :cancel_reason_code, :lock_version, :time_zone, :confirmation_date, :confirmation_phone, :confirmation_notes, :home_health_appointment)

    # Uncomment to use Pundit permitted attributes
    # params.require(:appointment).permit(policy(@appointment).permitted_attributes)
  end
end
