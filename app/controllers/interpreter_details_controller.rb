class InterpreterDetailsController < ApplicationController
  before_action :set_interpreter_detail, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /interpreter_details
  def index
    @pagy, @interpreter_details = pagy(InterpreterDetail.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @interpreter_details
  end

  # GET /interpreter_details/1 or /interpreter_details/1.json
  def show
  end

  # GET /interpreter_details/new
  def new
    @interpreter_detail = InterpreterDetail.new

    # Uncomment to authorize with Pundit
    # authorize @interpreter_detail
  end

  # GET /interpreter_details/1/edit
  def edit
  end

  # POST /interpreter_details or /interpreter_details.json
  def create
    @interpreter_detail = InterpreterDetail.new(interpreter_detail_params)

    # Uncomment to authorize with Pundit
    # authorize @interpreter_detail

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
    @interpreter_detail.destroy
    respond_to do |format|
      format.html { redirect_to interpreter_details_url, status: :see_other, notice: "Interpreter detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_interpreter_detail
    @interpreter_detail = InterpreterDetail.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @interpreter_detail
  rescue ActiveRecord::RecordNotFound
    redirect_to interpreter_details_path
  end

  # Only allow a list of trusted parameters through.
  def interpreter_detail_params
    params.require(:interpreter_detail).permit(:interpreter_type, :gender, :primary_phone, :interpreter_id, :ssn, :dob, :address,
      :city, :state, :zip, :start_date, :drivers_license, :emergency_contact_name, :emergency_contact_phone)

    # Uncomment to use Pundit permitted attributes
    # params.require(:interpreter_detail).permit(policy(@interpreter_detail).permitted_attributes)
  end
end
