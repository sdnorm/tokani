class CustomerCategoriesController < ApplicationController
  before_action :set_customer_category, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /customer_categories
  def index
    @pagy, @customer_categories = pagy(CustomerCategory.where(account_id: current_account.id).alphabetical.sort_by_params(params[:sort], sort_direction))
    # @pagy, @customer_categories = pagy(CustomerCategory.sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @customer_categories
  end

  # GET /customer_categories/1 or /customer_categories/1.json
  def show
  end

  # GET /customer_categories/new
  def new
    @customer_category = CustomerCategory.new

    # Uncomment to authorize with Pundit
    # authorize @customer_category
  end

  # GET /customer_categories/1/edit
  def edit
  end

  # POST /customer_categories or /customer_categories.json
  def create
    @customer_category = CustomerCategory.new(customer_category_params)
    if agency_logged_in?
      @customer_category.account_id = current_account.id
    end
    # Uncomment to authorize with Pundit
    # authorize @customer_category

    respond_to do |format|
      if @customer_category.save
        format.html { redirect_to @customer_category, notice: "Customer category was successfully created." }
        format.json { render :show, status: :created, location: @customer_category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customer_categories/1 or /customer_categories/1.json
  def update
    respond_to do |format|
      if @customer_category.update(customer_category_params)
        format.html { redirect_to @customer_category, notice: "Customer category was successfully updated." }
        format.json { render :show, status: :ok, location: @customer_category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer_categories/1 or /customer_categories/1.json
  def destroy
    @customer_category.destroy
    respond_to do |format|
      format.html { redirect_to customer_categories_url, status: :see_other, notice: "Customer category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer_category
    @customer_category = CustomerCategory.find(params[:id])

    # Uncomment to authorize with Pundit
    # authorize @customer_category
  rescue ActiveRecord::RecordNotFound
    redirect_to customer_categories_path
  end

  # Only allow a list of trusted parameters through.
  def customer_category_params
    params.require(:customer_category).permit(:display_value, :appointment_prefix, :telephone_prefix, :video_prefix, :is_active, :account_id)

    # Uncomment to use Pundit permitted attributes
    # params.require(:customer_category).permit(policy(@customer_category).permitted_attributes)
  end
end
