class BillRatesController < ApplicationController
  before_action :set_bill_rate, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /bill_rates
  def index
    # This assumes billrate is only accessible to agency-type accounts
    @pagy, @bill_rates = pagy(BillRate.where(account_id: current_account.id).sort_by_params(params[:sort], sort_direction))
    # @pagy, @bill_rates = pagy(BillRate.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @bill_rates
  end

  # GET /bill_rates/1 or /bill_rates/1.json
  def show
  end

  # GET /bill_rates/new
  def new
    @bill_rate = BillRate.new
    @languages = current_account.languages.all.order("name ASC")
    @customers = current_account.customers.order("name ASC")

    @languages_json = current_account.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @customers_json = current_account.customers.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json

    # Uncomment to authorize with Pundit
    # authorize @bill_rate
  end

  # GET /bill_rates/1/edit
  def edit
    @languages = current_account.languages.all.order("name ASC")
    @customers = current_account.customers.order("name ASC")

    @languages_json = current_account.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @customers_json = current_account.customers.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @br_languages_json = @bill_rate.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @br_customers_json = @bill_rate.customers.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @languages_disabled = @bill_rate.default_rate
  end

  # POST /bill_rates or /bill_rates.json
  def create
    @bill_rate = BillRate.new(bill_rate_params)
    @bill_rate.make_regularhours_times_from_hash(params[:times])
    # Uncomment to authorize with Pundit
    # authorize @bill_rate

    respond_to do |format|
      if @bill_rate.save
        format.html { redirect_to @bill_rate, notice: "Bill rate was successfully created." }
        format.json { render :show, status: :created, location: @bill_rate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bill_rates/1 or /bill_rates/1.json
  def update
    @languages_json = current_account.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @customers_json = current_account.customers.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @br_languages_json = @bill_rate.languages.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @br_customers_json = @bill_rate.customers.pluck(:id, :name).map { |u| {value: u[0], text: u[1]} }.to_json
    @languages_disabled = @bill_rate.default_rate

    if params[:times].present?
      @bill_rate.make_regularhours_times_from_hash(params[:times])
    end
    respond_to do |format|
      if @bill_rate.update(bill_rate_params)
        format.html { redirect_to @bill_rate, notice: "Bill rate was successfully updated." }
        format.json { render :show, status: :ok, location: @bill_rate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bill_rates/1 or /bill_rates/1.json
  def destroy
    @bill_rate.destroy
    respond_to do |format|
      format.html { redirect_to bill_rates_url, status: :see_other, notice: "Bill rate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bill_rate
    @bill_rate = BillRate.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @bill_rate
  rescue ActiveRecord::RecordNotFound
    redirect_to bill_rates_path
  end

  # Only allow a list of trusted parameters through.
  def bill_rate_params
    params.require(:bill_rate).permit(:account_id, :name, :hourly_bill_rate, :is_active, :minimum_time_charged, :round_time, :round_increment, :after_hours_overage, :regular_hours_start_seconds, :regular_hours_end_seconds, :rush_overage, :rush_overage_trigger, :cancel_rate, :cancel_rate_trigger, :default_rate, :in_person, :phone, :video, language_ids: [], customer_ids: [])

    # Uncomment to use Pundit permitted attributes
    # params.require(:bill_rate).permit(policy(@bill_rate).permitted_attributes)
  end
end
