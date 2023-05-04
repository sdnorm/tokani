class RequestorsController < ApplicationController
  include CurrentHelper

  before_action :authenticate_user!
  before_action :set_requestor, only: [:show, :edit, :update, :destroy]
  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def index
    if agency_logged_in?
      customer_ids = current_account.agency_customers.pluck(:customer_id)
      @requestor_accounts = CustomerRequestor.where(customer_id: customer_ids).pluck(:requestor_id)

    else
      @requestor_accounts = current_account.account_users.client.pluck(:user_id)
      @requestor_accounts << current_account.account_users.site_member.pluck(:user_id)
      @requestor_accounts << current_account.account_users.site_admin.pluck(:user_id)
      @requestor_accounts << current_account.account_users.customer_admin.pluck(:user_id)
    end

    @pagy, @requestors = pagy(User.where(id: @requestor_accounts.flatten).sort_by_params(params[:sort], sort_direction))
  end

  def new
    @requestor = User.new
    @requestor.build_requestor_detail

    if agency_logged_in?
      customer_ids = current_account.agency_customers.pluck(:customer_id)
      @account_customers = Customer.where(id: customer_ids)
    else
      @account_customers = current_account.customers
    end

    if params[:customer_id].present?
      @customer_id = params[:customer_id]
      @customer = Customer.find(@customer_id)
      @sites = @customer.sites.order("name ASC")
      @departments = Department.where(site_id: @site_id).order("name ASC")
    end
    # @sites = customer_logged_in? ? Customer.find(current_user.requestor_detail.customer_id).sites : []
    @sites ||= (!agency_logged_in?) ? current_account.sites : []
    #  @departments = Department.where(site_id: @sites).order("name ASC")
    @departments ||= []
    @remote = params[:remote] == "true"
  end

  def show
    @account_customers = current_account.customers
  end

  def edit
    if agency_logged_in?
      customer_ids = current_account.agency_customers.pluck(:customer_id)
      @account_customers = Customer.where(id: customer_ids)
    else
      @account_customers = current_account.customers
    end
    @sites = agency_logged_in? ? current_account.account_sites.order("name ASC") : current_account.sites.order("name ASC")
    # @sites = customer_logged_in? ? current_account.sites.order("name ASC") : current_account.account_sites.order("name ASC")
    @departments = if @requestor.requestor_detail.site_id.present?
      Department.where(site_id: @requestor.requestor_detail.site_id).order("name ASC")
    else
      []
    end
  end

  def create
    @requestor = User.new(requestor_params)
    @account_customers = current_account.customers
    @sites = current_account.account_sites.order("name ASC")
    @departments = if @requestor.requestor_detail.site_id.present?
      Department.where(site_id: @requestor.requestor_detail.site_id).order("name ASC")
    else
      []
    end

    @requestor.terms_of_service = true
    @requestor.password = SecureRandom.alphanumeric
    @requestor.accepted_terms_at = Time.current

    unless agency_logged_in?
      @requestor.requestor_detail.customer_id = current_account.id
      # @requestor.requestor_detail.customer_id = current_user.requestor_detail.customer_id
    end
    # @requestor.requestor_detail.customer_id = current_account.id
    # @requestor.requestor_detail.requestor_type = 4
    # req_type = {"customer_admin" => true}
    # else
    req_type = requestor_params[:requestor_detail_attributes][:requestor_type]
    # end

    if req_type == "site_admin"
      req_type = {"site_admin" => true}
    end
    if req_type == "site_member"
      req_type = {"site_member" => true}
    end
    if req_type == "client"
      req_type = {"client" => true}
    end

    if req_type == "customer_admin"
      req_type = {"customer_admin" => true}
    end
    # @requestor.skip_default_account = true

    respond_to do |format|
      if @requestor.save
        AccountUser.create!(account_id: current_account.id, user_id: @requestor.id, roles: req_type)
        CustomerRequestor.create!(requestor_id: @requestor.id, customer_id: @requestor.requestor_detail.customer_id)
        AgencyAdminRequestorCreationMailer.welcome(@requestor).deliver_later
        format.html { redirect_to requestor_path(@requestor), notice: "Requestor was successfully created." }
        format.json { render :show, status: :created, location: @requestor }
      else

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @requestor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requestors/1 or /requestors/1.json
  def update
    respond_to do |format|
      @account_customers = current_account.customers
      @sites = current_account.account_sites.order("name ASC")

      if @requestor.update!(requestor_params)
        notice = if @requestor.unconfirmed_email_updated
          "Requestor was successfully updated.<br> A confirmation email was sent to #{@requestor.unconfirmed_email}."
        else
          "Requestor was successfully updated."
        end
        format.html { redirect_to requestor_path(@requestor), notice: notice }
        format.json { render :show, status: :ok, location: @requestor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @requestor.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_requestor
    if agency_logged_in?
      @requestor = User.find(params[:id])
    else

      requestor = current_account.account_users.client.find_by(user_id: params[:id])
      requestor ||= current_account.account_users.site_admin.find_by(user_id: params[:id])
      requestor ||= current_account.account_users.site_member.find_by(user_id: params[:id])

      # requestor ||= current_account.account_users.customer_admin.find_by(user_id: params[:id]) if customer_logged_in?
      requestor ||= current_account.account_users.customer_admin.find_by(user_id: params[:id])

      req_id = requestor.user_id
      @requestor = User.find_by(id: req_id)
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to requestors_path
  end

  # Only allow a list of trusted parameters through.
  def requestor_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :terms_of_service,
      requestor_detail_attributes: [
        :id,
        :site_id,
        :department_id,
        :customer_id,
        :allow_offsite,
        :allow_view_docs,
        :allow_view_checklist,
        :requestor_type,
        :primary_phone,
        :work_phone
      ]
    )
  end
end
