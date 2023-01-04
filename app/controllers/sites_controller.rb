class SitesController < ApplicationController
  include CurrentHelper

  before_action :set_site, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /sites
  def index
    # @pagy, @sites = pagy(Site.sort_by_params(params[:sort], sort_direction))
    @pagy, @sites = pagy(current_account.account_sites.sort_by_params(params[:sort], sort_direction))

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
    # Uncomment to authorize with Pundit
    # authorize @site
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites or /sites.json
  def create
    @site = Site.new(site_params)
    @site.account_id = current_account.id

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
    @site = current_account.account_sites.find(params[:id])

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
