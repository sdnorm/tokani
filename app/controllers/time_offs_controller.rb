class TimeOffsController < ApplicationController
  # before_action :set_interpreter
  before_action :set_time_off, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /time_offs
  def index
    authorize @time_offs, policy_class: TimeOffPolicy
    @pagy, @time_offs = pagy(TimeOff.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @time_offs
  end

  # GET /time_offs/1 or /time_offs/1.json
  def show
  end

  # GET /time_offs/new
  def new
    @time_off = TimeOff.new
    authorize @time_off

    # Uncomment to authorize with Pundit
    # authorize @time_off
  end

  # GET /time_offs/1/edit
  def edit
  end

  # POST /time_offs or /time_offs.json
  def create
    @time_off = TimeOff.new(
      time_off_params.merge!(interpreter: current_account_user.user)
    )

    authorize @time_off

    # Uncomment to authorize with Pundit
    # authorize @time_off

    respond_to do |format|
      if @time_off.save
        format.html { redirect_to time_offs_path, notice: "Time off was successfully created." }
        format.json { render :show, status: :created, location: @time_off }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_off.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_offs/1 or /time_offs/1.json
  def update
    authorize @time_off

    respond_to do |format|
      if @time_off.update(time_off_params)
        format.html { redirect_to @time_off, notice: "Time off was successfully updated." }
        format.json { render :show, status: :ok, location: @time_off }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_off.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_offs/1 or /time_offs/1.json
  def destroy
    authorize @time_off

    @time_off.destroy
    respond_to do |format|
      format.html { redirect_to time_offs_url, status: :see_other, notice: "Time off was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_time_off
    # @time_off = TimeOff.find(params[:id])
    @time_off = policy_scope(TimeOff).find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @time_off
  rescue ActiveRecord::RecordNotFound
    redirect_to time_offs_path
  end

  def set_interpreter
    @interpreter = current_account_user.user
  end

  # Only allow a list of trusted parameters through.
  def time_off_params
    params.require(:time_off).permit(:start_datetime, :end_datetime, :reason)

    # Uncomment to use Pundit permitted attributes
    # params.require(:time_off).permit(policy(@time_off).permitted_attributes)
  end
end
