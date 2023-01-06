class LanguagesController < ApplicationController
  include CurrentHelper
  before_action :set_language, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /languages
  def index
    @pagy, @languages = pagy(current_account.account_languages.sort_by_params(params[:sort], sort_direction))
    # @pagy, @languages = pagy(Language.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @languages
  end

  # GET /languages/1 or /languages/1.json
  def show
  end

  # GET /languages/new
  def new
    @language = Language.new

    # Uncomment to authorize with Pundit
    # authorize @language
  end

  # GET /languages/1/edit
  def edit
  end

  # POST /languages or /languages.json
  def create
    @language = Language.new(language_params)

    # Uncomment to authorize with Pundit
    # authorize @language

    respond_to do |format|
      if @language.save
        format.html { redirect_to @language, notice: "Language was successfully created." }
        format.json { render :show, status: :created, location: @language }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /languages/1 or /languages/1.json
  def update
    respond_to do |format|
      if @language.update(language_params)
        format.html { redirect_to @language, notice: "Language was successfully updated." }
        format.json { render :show, status: :ok, location: @language }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @language.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /languages/1 or /languages/1.json
  def destroy
    @language.destroy
    respond_to do |format|
      format.html { redirect_to languages_url, status: :see_other, notice: "Language was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_language
    @language = current_account.account_languages.find(params[:id])
    # Uncomment to authorize with Pundit
    # authorize @language
  rescue ActiveRecord::RecordNotFound
    redirect_to languages_path
  end

  # Only allow a list of trusted parameters through.

  def language_params
    params.require(:language).permit(:name, :account_id, :is_active)

    # Uncomment to use Pundit permitted attributes
    # params.require(:language).permit(policy(@language).permitted_attributes)
  end
end
