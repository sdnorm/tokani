class RequestorsController < ApplicationController
  include CurrentHelper

  before_action :authenticate_user!
  before_action :set_requestor, only: [:show, :edit, :update, :destroy]
  # Uncomment to enforce Pundit authorization
  # after_action :verify_authorized
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # GET /interpreters
  def index
    @requestor_accounts = AccountUser.client.pluck(:user_id)
    @requestor_accounts << AccountUser.site_member.pluck(:user_id)
    @requestor_accounts << AccountUser.site_admin.pluck(:user_id)

    @pagy, @requestors = pagy(User.where(id: @requestor_accounts.flatten).sort_by_params(params[:sort], sort_direction))
  end

  def new
    @requestor = User.new
    @requestor.build_requestor_detail
    @account_customers = current_account.customers
  end

  def show
    @account_customers = current_account.customers
  end

  def edit
    @account_customers = current_account.customers
  end

  def create
    @requestor = User.new(requestor_params)
    @requestor.terms_of_service = true
    req_type = requestor_params[:requestor_detail_attributes][:requestor_type]

    if req_type == "site_admin"
      req_type = {"site_admin" => true}
    end
    if req_type == "site_member"
      req_type = {"site_member" => true}
    end
    if req_type == "client"
      req_type = {"client" => true}
    end

    respond_to do |format|
      if @requestor.save
        AccountUser.create!(account_id: current_account.id, user_id: @requestor.id, roles: req_type)
        format.html { redirect_to requestor_path(@requestor), notice: "Requestor was successfully created." }
        format.json { render :show, status: :created, location: @requestor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @interpreter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requestors/1 or /requestors/1.json
  def update
    respond_to do |format|
      @account_customers = current_account.customers

      if @requestor.update(requestor_params)

        format.html { redirect_to requestor_path(@requestor), notice: "Requestor was successfully updated." }
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
    requestor = current_account.account_users.client.find_by(user_id: params[:id])
    requestor ||= current_account.account_users.site_admin.find_by(user_id: params[:id])
    requestor ||= current_account.account_users.site_member.find_by(user_id: params[:id])
    req_id = requestor.user_id
    @requestor = User.find_by(id: req_id)
  rescue ActiveRecord::RecordNotFound
    redirect_to requestors_path
  end

  # Only allow a list of trusted parameters through.
  def requestor_params
    params.require(:user).permit(
      :email,
      :password,
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
