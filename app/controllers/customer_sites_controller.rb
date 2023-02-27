class CustomerSitesController < ApplicationController
  # include CurrentHelper

  before_action :current_account, only: [:index, :create, :show, :edit, :update]
  before_action :set_customer_site, only: [:show, :edit, :update, :destroy]

  def index 
    @pagy, @sites = pagy(@current_account.account_sites.sort_by_params(params[:sort], sort_direction))
  end
  
  def new
    @site = Site.new
    # setup_site_vars
  end

  def create
    @site = Site.new(customer_site_params)
    @site.account_id = @current_account.id
    @site.customer_id = @customer.id
    # Uncomment to authorize with Pundit
    # authorize @site

    respond_to do |format|
      if @site.save
        format.html { redirect_to customer_site_path(@site), notice: "Site was successfully created." }
        format.json { render :show, status: :created, location: @site }
      else
        # setup_site_vars
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @site.update(customer_site_params)
        format.html { redirect_to customer_site_path(@site), notice: "Site was successfully updated." }
        format.json { render :show, status: :ok, location: @site }
      else
        # setup_site_vars
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url, status: :see_other, notice: "Site was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def current_account
    @customer = Customer.first
    @current_account = @customer.owner.accounts.first
  end

  def set_customer_site
    @site = @current_account.account_sites.find(params[:id])
  end

  def customer_site_params
    params.require(:site).permit(
      :name, :contact_name, :email, :address, :city, :state, :zip_code, :active, :notes, :contact_phone, :customer_id, :departments,
      departments_attributes: %i[id name location accounting_unit_code]
    )
  end

  # def setup_site_vars
    # @customers = current_account.customers

    # @customer_id = current_customer.id
    # @customer_id = site_params[:customer_id] if params[:site].present? && site_params[:customer_id].present?
    # @site.customer_id = Customer.first.id
  # end
end