class PayRatesController < ApplicationController
  before_action :set_pay_rate, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /pay_rates
  def index
    @pagy, @pay_rates = pagy(PayRate.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @pay_rates
  end

  # GET /pay_rates/1 or /pay_rates/1.json
  def show
  end

  # GET /pay_rates/new
  def new
    @pay_rate = PayRate.new
    @interpreters = current_account.account_interpreters
    @languages = current_account.languages.all.order("name ASC")

    @languages_json = current_account.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @interpreters_json = current_account.account_interpreters.pluck(:id, :first_name, :last_name).map { |u| {value: u[0], text: u[1] + u[2]} }.to_json

    # Uncomment to authorize with Pundit
    # authorize @pay_rate
  end

  # GET /pay_rates/1/edit
  def edit
    @languages_json = current_account.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @interpreters_json = current_account.account_interpreters.pluck(:id, :first_name, :last_name).map { |u| {value: u[0], text: [u[1], u[2]].join(" ")} }.to_json

    @pr_languages_json = @pay_rate.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @default_disabled = !@pay_rate.languages.empty?
  end

  # POST /pay_rates or /pay_rates.json
  def create
    @pay_rate = PayRate.new(pay_rate_params)

    # Uncomment to authorize with Pundit
    # authorize @pay_rate

    respond_to do |format|
      if @pay_rate.save
        format.html { redirect_to @pay_rate, notice: "Pay rate was successfully created." }
        format.json { render :show, status: :created, location: @pay_rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pay_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pay_rates/1 or /pay_rates/1.json
  def update
    respond_to do |format|
      if @pay_rate.update(pay_rate_params)
        format.html { redirect_to @pay_rate, notice: "Pay rate was successfully updated." }
        format.json { render :show, status: :ok, location: @pay_rate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pay_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pay_rates/1 or /pay_rates/1.json
  def destroy
    @pay_rate.destroy
    respond_to do |format|
      format.html { redirect_to pay_rates_url, status: :see_other, notice: "Pay rate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pay_rate
    @pay_rate = PayRate.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @pay_rate
  rescue ActiveRecord::RecordNotFound
    redirect_to pay_rates_path
  end

  # Only allow a list of trusted parameters through.
  def pay_rate_params
    params.require(:pay_rate).permit(:account_id, :name, :hourly_pay_rate, :is_active, :minimum_time_charged, :after_hours_overage, :rush_overage, :cancel_rate, :default_rate, :in_person, :phone, :video, language_ids: [], interpreter_ids: [])

    # Uncomment to use Pundit permitted attributes
    # params.require(:pay_rate).permit(policy(@pay_rate).permitted_attributes)
  end
end
