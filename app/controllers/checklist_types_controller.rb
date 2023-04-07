class ChecklistTypesController < ApplicationController
  include CurrentHelper
  before_action :set_checklist_type, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /checklist_types
  def index
    @pagy, @checklist_types = pagy(current_account.checklist_types.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @checklist_types
  end

  # GET /checklist_types/1 or /checklist_types/1.json
  def show
  end

  # GET /checklist_types/new
  def new
    @checklist_type = ChecklistType.new

    # Uncomment to authorize with Pundit
    # authorize @checklist_type
  end

  # GET /checklist_types/1/edit
  def edit
  end

  # POST /checklist_types or /checklist_types.json
  def create
    @checklist_type = ChecklistType.new(checklist_type_params)
    @checklist_type.account_id = current_account.id

    # Uncomment to authorize with Pundit
    # authorize @checklist_type

    respond_to do |format|
      if @checklist_type.save
        format.html { redirect_to @checklist_type, notice: "Checklist type was successfully created." }
        format.json { render :show, status: :created, location: @checklist_type }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @checklist_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /checklist_types/1 or /checklist_types/1.json
  def update
    respond_to do |format|
      if @checklist_type.update(checklist_type_params)
        format.html { redirect_to @checklist_type, notice: "Checklist type was successfully updated." }
        format.json { render :show, status: :ok, location: @checklist_type }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @checklist_type.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_checklist_type
    @checklist_type = current_account.checklist_types.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @checklist_type
  rescue ActiveRecord::RecordNotFound
    redirect_to checklist_types_path
  end

  # Only allow a list of trusted parameters through.
  def checklist_type_params
    params.require(:checklist_type).permit(:name, :code, :is_active, :backport_id, :requires_expiration, :requires_upload)

    # Uncomment to use Pundit permitted attributes
    # params.require(:checklist_type).permit(policy(@checklist_type).permitted_attributes)
  end
end
