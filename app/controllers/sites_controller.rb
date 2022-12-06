class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /sites
  def index
    @pagy, @sites = pagy(Site.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @sites
  end

  # GET /sites/1 or /sites/1.json
  def show
  end

  # GET /sites/new
  def new
    @site = Site.new

    # Uncomment to authorize with Pundit
    # authorize @site
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites or /sites.json
  def create
    @site = Site.new(site_params)

    # Uncomment to authorize with Pundit
    # authorize @site

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: "Site was successfully created." }
        format.json { render :show, status: :created, location: @site }
      else
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

  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = Site.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @site
  rescue ActiveRecord::RecordNotFound
    redirect_to sites_path
  end

  # Only allow a list of trusted parameters through.
  def site_params
    params.require(:site).permit(:name, :contact_name, :email, :address, :city, :state, :zip_code, :active, :backport_id, :notes, :contact_phone)

    # Uncomment to use Pundit permitted attributes
    # params.require(:site).permit(policy(@site).permitted_attributes)
  end
end
