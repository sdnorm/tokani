class RequestorDetailsController < ApplicationController
  before_action :set_requestor_detail, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /requestor_details
  def index
    @pagy, @requestor_details = pagy(RequestorDetail.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @requestor_details
  end

  # GET /requestor_details/1 or /requestor_details/1.json
  def show
  end

  # GET /requestor_details/new
  def new
    @requestor_detail = RequestorDetail.new

    # Uncomment to authorize with Pundit
    # authorize @requestor_detail
  end

  # GET /requestor_details/1/edit
  def edit
  end

  # POST /requestor_details or /requestor_details.json
  def create
    @requestor_detail = RequestorDetail.new(requestor_detail_params)

    # Uncomment to authorize with Pundit
    # authorize @requestor_detail

    respond_to do |format|
      if @requestor_detail.save
        format.html { redirect_to @requestor_detail, notice: "Requestor detail was successfully created." }
        format.json { render :show, status: :created, location: @requestor_detail }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @requestor_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requestor_details/1 or /requestor_details/1.json
  def update
    respond_to do |format|
      if @requestor_detail.update(requestor_detail_params)
        format.html { redirect_to @requestor_detail, notice: "Requestor detail was successfully updated." }
        format.json { render :show, status: :ok, location: @requestor_detail }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @requestor_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requestor_details/1 or /requestor_details/1.json
  def destroy
    @requestor_detail.destroy
    respond_to do |format|
      format.html { redirect_to requestor_details_url, status: :see_other, notice: "Requestor detail was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_requestor_detail
    @requestor_detail = RequestorDetail.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @requestor_detail
  rescue ActiveRecord::RecordNotFound
    redirect_to requestor_details_path
  end

  # Only allow a list of trusted parameters through.
  def requestor_detail_params
    params.fetch(:requestor_detail, {})

    # Uncomment to use Pundit permitted attributes
    # params.require(:requestor_detail).permit(policy(@requestor_detail).permitted_attributes)
  end
end
