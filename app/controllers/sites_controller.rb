class SitesController < ApplicationController
  include CurrentHelper

  before_action :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /sites
  def index
    # @pagy, @sites = pagy(Site.sort_by_params(params[:sort], sort_direction))
    if agency_logged_in?
      customer_ids = current_account.agency_customers.pluck(:customer_id)
      @pagy, @sites = pagy(Site.where(customer_id: customer_ids).sort_by_params(params[:sort], sort_direction))
    else
      @pagy, @sites = pagy(current_account.sites.sort_by_params(params[:sort], sort_direction))
    end

    # Uncomment to authorize with Pundit
    # authorize @sites
  end

  # GET /sites/1 or /sites/1.json
  def show
  end

  # GET /sites/new
  def new
    @site = Site.new
    @customer_id = params[:customer_id]
    setup_site_vars
    unless agency_logged_in?
      @customer = Customer.find(current_account.id)
    end
    # Uncomment to authorize with Pundit
    # authorize @site
  end

  # GET /sites/1/edit
  def edit
    @customer = Customer.find(@site.customer_id)
  end

  def select_list
    @target = params[:target]
    @clear_target = params[:clear]
    customer_id = params[:customer_id]

    if @target.blank? || customer_id.blank?
      render turbo_stream: "", status: :unprocessable_entity
      return false
    end

    sites = current_account.account_sites.where(customer_id: customer_id).order("name ASC")
    @site_list = [["Please Select Site", ""]] + sites.map { |site| [site.name, site.id] }
  end

  def department_select_list
    @target = params[:target]
    site_id = params[:site_id]

    if @target.blank? || site_id.blank?
      render turbo_stream: "", status: :unprocessable_entity
      return false
    end

    departments = Department.where(site_id: site_id).order("name ASC")
    @department_list = [["None", ""]]
    @department_list += departments.map { |dept| [dept.name, dept.id] } if departments.present?
  end

  def dropdown
    @account_id = params[:account_id]
    @sites = current_account.account_sites.where(customer_id: @account_id).order("name ASC")
    render layout: nil
  end

  def dropdown_for_reports
    @customer_id = params[:agency_customer_id]
    @sites = current_account.account_sites.where(customer_id: @customer_id).order("name ASC")
    render layout: nil
  end

  def departments_dropdown
    site_ids = (params[:site_ids] || "").split(",")
    @departments = Department.where(site_id: site_ids).order("name ASC")
    render layout: nil
  end

  def departments_dropdown_for_reports
    site_ids = (params[:site_ids] || "").split(",")
    @departments = Department.where(site_id: site_ids).order("name ASC")
    render layout: nil
  end

  # POST /sites or /sites.json
  def create
    @site = Site.new(site_params)
    @site.account_id = current_account.id
    @site.customer_id = current_account.id if customer_logged_in?

    # Uncomment to authorize with Pundit
    # authorize @site

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: "Site was successfully created." }
        format.json { render :show, status: :created, location: @site }
      else
        setup_site_vars
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1 or /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: "Site was successfully updated." }
        format.json { render :show, status: :ok, location: @site }
      else
        setup_site_vars
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1 or /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url, status: :see_other, notice: "Site was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def setup_site_vars
    @customers = current_account.customers
    @customer_id = site_params[:customer_id] if params[:site].present? && site_params[:customer_id].present?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = if agency_logged_in?
      current_account.account_sites.find(params[:id])
    else
      current_account.sites.find(params[:id])
    end
    # Uncomment to authorize with Pundit
    # authorize @site
  rescue ActiveRecord::RecordNotFound
    redirect_to sites_path
  end

  # Only allow a list of trusted parameters through.
  def site_params
    params.require(:site).permit(:name, :contact_name, :email, :address, :city, :state, :zip_code, :active, :notes, :contact_phone, :customer_id, :departments,
      departments_attributes: %i[id name location accounting_unit_code])

    # Uncomment to use Pundit permitted attributes
    # params.require(:site).permit(policy(@site).permitted_attributes)
  end
end
