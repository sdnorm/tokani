class CustomersController < ApplicationController
  include CurrentHelper

  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /customers
  def index
    @pagy, @customers = pagy(current_account.customers.includes(:customer_detail).sort_by_params(params[:sort], sort_direction))

    # Uncomment to authorize with Pundit
    # authorize @customers
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @customer.build_customer_detail
    @customer.build_physical_address
    @customer_categories = CustomerCategory.where(account_id: current_account.id).order("display_value ASC")

    # Uncomment to authorize with Pundit
    # authorize @customer
  end

  # GET /customers/1/edit
  def edit
    @customer_categories = CustomerCategory.where(account_id: current_account.id).order("display_value ASC")
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)
    @customer_categories = CustomerCategory.where(account_id: current_account.id).order("display_value ASC")
    # Uncomment to authorize with Pundit
    # authorize @customer
    respond_to do |format|
      if @customer.save
        CreateCustomerOwnerUserAccountJob.perform_later(@customer.id)
        AgencyCustomer.create!(agency: current_account, customer: @customer)

        format.html { redirect_to @customer, notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    @customer_categories = CustomerCategory.where(account_id: current_account.id).order("display_value ASC")
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: "Customer was successfully updated." }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def customer_details
  end

  def customer_details_edit
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, status: :see_other, notice: "Customer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = current_account.customers.find(params[:id])
    @customer = @customer.becomes(Customer)
    # Uncomment to authorize with Pundit
    # authorize @customer
  rescue ActiveRecord::RecordNotFound
    redirect_to customers_path
  end

  # Only allow a list of trusted parameters through.
  def customer_params
    params.require(:customer).permit(
      :name,
      :is_active,
      physical_address_attributes: [
        :id,
        :line1,
        :line2,
        :city,
        :state,
        :postal_code,
        :address_type
      ],
      customer_detail_attributes: [
        :id,
        :contact_name,
        :email,
        :fax,
        :phone,
        :notes,
        :appointments_in_person,
        :appointments_video,
        :appointments_phone,
        :customer_category_id
      ]
    )

    # Uncomment to use Pundit permitted attributes
    # params.require(:customer).permit(policy(@customer).permitted_attributes)
  end
end
