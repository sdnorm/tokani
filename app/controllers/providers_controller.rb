class ProvidersController < ApplicationController
  include CurrentHelper
  before_action :set_provider, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /providers
  def index
    if agency_logged_in?
      customer_ids = current_account.agency_customers.pluck(:customer_id)
      @pagy, @providers = pagy(Provider.where(customer_id: customer_ids).sort_by_params(params[:sort], sort_direction))
       
    else
      customer = current_account.id
      @pagy, @providers = pagy(Provider.where(customer_id: customer).sort_by_params(params[:sort], sort_direction))

    end


    # Uncomment to authorize with Pundit
    # authorize @providers
  end

  # GET /providers/1 or /providers/1.json
  def show
  end

  # GET /providers/new
  def new
    @provider = Provider.new
    # @account_customers = current_account.customers unless customer_logged_in?
    @account_customers = current_account.customers 

    if params[:customer_id].present?
      @customer_id = params[:customer_id]
      @customer = Customer.find(@customer_id)
      @sites = @customer.sites.order("name ASC")
      @departments = Department.where(site_id: @site_id).order("name ASC")

    end
    @sites = agency_logged_in? ? current_account.account_sites.order("name ASC") : current_account.sites.order("name ASC")
    # @sites ||= customer_logged_in? ? current_account.sites : []
    @departments ||= []

    # Uncomment to authorize with Pundit
    # authorize @provider
  end

  # GET /providers/1/edit
  def edit
    @account_customers = current_account.customers unless customer_logged_in?
    @sites = agency_logged_in? ? current_account.account_sites.order("name ASC"): current_account.sites.order("name ASC") 
byebug
    @departments = if @provider.site_id.present?
      Department.where(site_id: @provider.site_id).order("name ASC")
    else
      []
    end
  end

  # POST /providers or /providers.json
  def create
    @provider = Provider.new(provider_params)
    @account_customers = current_account.customers
    @provider.customer_id = current_account.id unless agency_logged_in?
    @sites = current_account.account_sites.order("name ASC")
    @departments = if @provider.site_id.present?
      Department.where(site_id: @provider.site_id).order("name ASC")
    else
      []
    end

    respond_to do |format|
      if @provider.save

        format.html { redirect_to @provider, notice: "Provider was successfully created." }
        format.json { render :show, status: :created, location: @provider }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /providers/1 or /providers/1.json
  def update
    respond_to do |format|
      if @provider.update(provider_params)
        format.html { redirect_to @provider, notice: "Provider was successfully updated." }
        format.json { render :show, status: :ok, location: @provider }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /providers/1 or /providers/1.json
  def destroy
    @provider.destroy
    respond_to do |format|
      format.html { redirect_to providers_url, status: :see_other, notice: "Provider was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_provider
    @provider = Provider.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @provider
  rescue ActiveRecord::RecordNotFound
    redirect_to providers_path
  end

  # Only allow a list of trusted parameters through.
  def provider_params
    params.require(:provider).permit(:last_name, :first_name, :email, :primary_phone, :allow_text, :allow_email, :site_id, :department_id, :customer_id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:provider).permit(policy(@provider).permitted_attributes)
  end
end
