class SpecialtiesController < ApplicationController
  before_action :set_specialty, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /specialties
  def index
    @pagy, @specialties = pagy(Specialty.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @specialties
  end

  # GET /specialties/1 or /specialties/1.json
  def show
  end

  # GET /specialties/new
  def new
    @specialty = Specialty.new

    # Uncomment to authorize with Pundit
    # authorize @specialty
  end

  # GET /specialties/1/edit
  def edit
  end

  # POST /specialties or /specialties.json
  def create
    @specialty = Specialty.new(specialty_params)

    # Uncomment to authorize with Pundit
    # authorize @specialty

    respond_to do |format|
      if @specialty.save
        format.html { redirect_to @specialty, notice: "Specialty was successfully created." }
        format.json { render :show, status: :created, location: @specialty }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @specialty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specialties/1 or /specialties/1.json
  def update
    respond_to do |format|
      if @specialty.update(specialty_params)
        format.html { redirect_to @specialty, notice: "Specialty was successfully updated." }
        format.json { render :show, status: :ok, location: @specialty }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @specialty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specialties/1 or /specialties/1.json
  def destroy
    @specialty.destroy
    respond_to do |format|
      format.html { redirect_to specialties_url, status: :see_other, notice: "Specialty was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_specialty
    @specialty = Specialty.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @specialty
  rescue ActiveRecord::RecordNotFound
    redirect_to specialties_path
  end

  # Only allow a list of trusted parameters through.
  def specialty_params
    params.require(:specialty).permit(:name, :display_code, :is_active)

    # Uncomment to use Pundit permitted attributes
    # params.require(:specialty).permit(policy(@specialty).permitted_attributes)
  end
end
