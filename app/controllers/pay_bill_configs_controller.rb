class PayBillConfigsController < ApplicationController
  include CurrentHelper

  before_action :set_pay_bill_config, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /pay_bill_configs
  def index
    @pagy, @pay_bill_configs = pagy(current_account.pay_bill_configs.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @pay_bill_configs
  end

  # GET /pay_bill_configs/1 or /pay_bill_configs/1.json
  def show
    @customers = current_account.customers.order("name ASC")
    @interpreters = current_account.account_interpreters
  end

  # GET /pay_bill_configs/new
  def new
    @pay_bill_config = PayBillConfig.new

    # Uncomment to authorize with Pundit
    # authorize @pay_bill_config
  end

  # GET /pay_bill_configs/1/edit
  def edit
  end

  # POST /pay_bill_configs or /pay_bill_configs.json
  def create
    @pay_bill_config = PayBillConfig.new(pay_bill_config_params)
    @pay_bill_config.account_id = current_account.id
    @pay_bill_config.make_afterhours1_times_from_hash(params[:times])
    @pay_bill_config.make_afterhours2_times_from_hash(params[:times])
    @pay_bill_config.make_weekend1_times_from_hash(params[:times])
    @pay_bill_config.make_weekend2_times_from_hash(params[:times])

    # Uncomment to authorize with Pundit
    # authorize @pay_bill_config

    respond_to do |format|
      if @pay_bill_config.save
        format.html { redirect_to @pay_bill_config, notice: "Pay bill config was successfully created." }
        format.json { render :show, status: :created, location: @pay_bill_config }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pay_bill_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pay_bill_configs/1 or /pay_bill_configs/1.json
  def update
    respond_to do |format|
      if @pay_bill_config.update(pay_bill_config_params)
        format.html { redirect_to @pay_bill_config, notice: "Pay bill config was successfully updated." }
        format.json { render :show, status: :ok, location: @pay_bill_config }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pay_bill_config.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_bill_configs/1 or /pay_bill_configs/1.json
  def destroy
    @pay_bill_config.destroy
    respond_to do |format|
      format.html { redirect_to pay_bill_configs_url, status: :see_other, notice: "Pay bill config was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pay_bill_config
    @pay_bill_config = current_account.pay_bill_configs.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @pay_bill_config
  rescue ActiveRecord::RecordNotFound
    redirect_to pay_bill_configs_path
  end

  # Only allow a list of trusted parameters through.
  def pay_bill_config_params
    params.require(:pay_bill_config).permit(:name, :minimum_minutes_billed, :minimum_minutes_paid, :billing_increment,
      :trigger_for_billing_increment, :trigger_for_rush_rate, :trigger_for_discount_rate, :trigger_for_cancel_level1, :trigger_for_cancel_level2,
      :trigger_for_travel_time, :trigger_for_mileage, :maximum_mileage, :maximum_travel_time, :fixed_roundtrip_mileage,
      :afterhours_availability_start_seconds1, :afterhours_availability_end_seconds1, :afterhours_availability_start_seconds2,
      :afterhours_availability_end_seconds2, :weekend_availability_start_seconds1, :weekend_availability_end_seconds1,
      :weekend_availability_start_seconds2, :weekend_availability_end_seconds2, :is_minutes_billed_appointment_duration,
      :minimum_minutes_billed_cancelled_level_1, :minimum_minutes_paid_cancelled_level_1, :minimum_minutes_billed_cancelled_level_2,
      :minimum_minutes_paid_cancelled_level_2, :is_minutes_billed_cancelled_appointment_duration,
      customer_ids: [], interpreter_ids: [])

    # Uncomment to use Pundit permitted attributes
    # params.require(:pay_bill_config).permit(policy(@pay_bill_config).permitted_attributes)
  end
end
