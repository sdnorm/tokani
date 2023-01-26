class AgenciesController < ApplicationController
  before_action :set_agency, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /agencies
  def index
    # @pagy, @agencies = pagy(Account.where(agency: true).sort_by_params(params[:sort], sort_direction))
    @pagy, @agencies = pagy(Agency.where(agency: true).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @agencies
  end

  # GET /agencies/1 or /agencies/1.json
  def show
  end

  # GET /agencies/new
  def new
    @agency = Agency.new
    @agency.build_physical_address
    @user = User.new
    # Uncomment to authorize with Pundit
    # authorize @agency
  end

  # GET /agencies/1/edit
  def edit
  end

  # POST /agencies or /agencies.json
  def create
    @agency = Agency.new(agency_params)

    # Uncomment to authorize with Pundit
    # authorize @agency

    respond_to do |format|
      if @agency.save
        format.html { redirect_to @agency, notice: "Agency was successfully created." }
        format.json { render :show, status: :created, location: @agency }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agencies/1 or /agencies/1.json
  def update
    respond_to do |format|
      if @agency.update(agency_params)
        format.html { redirect_to @agency, notice: "Agency was successfully updated." }
        format.json { render :show, status: :ok, location: @agency }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agencies/1 or /agencies/1.json
  def destroy
    @agency.destroy
    respond_to do |format|
      format.html { redirect_to agencies_url, status: :see_other, notice: "Agency was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def tokani_create
    puts "HERE"
    @agency = Agency.new(agency_params)#.merge(agency: true)
    @user = User.new(user_params) 
    @user.password = SecureRandom.alphanumeric
    @user.terms_of_service = true
    @user.accepted_terms_at = Time.current
    @agency.account_users.new(user: @user)

    respond_to do |format|
      if @agency.save! && @user.save!
        @agency.account_users.update!(agency_admin: true)
        # @agency.account_users.new(user: @user)
        # AccountUser.create!(account: @agency, user: @user)
        @agency.update(owner:  @user)
        format.html { redirect_to @agency, notice: "Agency was successfully created." }
        format.json { render :show, status: :created, location: @agency }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end  

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_agency
    @agency = Agency.find(params[:id])
    @agency = @agency.becomes(Agency)
    # Uncomment to authorize with Pundit
    # authorize @agency
  rescue ActiveRecord::RecordNotFound
    redirect_to agencies_path
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end

  # Only allow a list of trusted parameters through.
  def agency_params
    # params.fetch(:agency, {})
    params.require(:agency).permit(
      :name,
      physical_address_attributes: [
        :id,
        :line1,
        :line2,
        :city,
        :state,
        :postal_code,
        :address_type
      ]
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:agency).permit(policy(@agency).permitted_attributes)
  end
end
