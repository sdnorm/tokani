class AgencyDetailsController < ApplicationController
  include CurrentHelper
  before_action :set_agency
  before_action :verify_authorized

  def new
    @agency.build_physical_address
    @agency.build_agency_detail
  end

  def show
    @agency_detail = @agency.agency_detail
  end

  def edit
  end

  def create
    respond_to do |format|
      if @agency.update(account_params)
        format.html { redirect_to agency_detail_path(current_account.agency_detail), notice: "Agency Details were successfully updated." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @agency.update(account_params)
        format.html { redirect_to agency_detail_path(current_account.agency_detail), notice: "Agency Details were successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_agency
    @agency = current_account
  end

  def verify_authorized
    raise Pundit::NotAuthorizedError unless current_user.is_agency_admin?
  end

  def account_params
    params.require(:account).permit(
      :name,
      physical_address_attributes: [
        :id,
        :line1,
        :line2,
        :city,
        :state,
        :postal_code,
        :address_type
      ],
      agency_detail_attributes: [
        :id,
        :company_website,
        :primary_contact_first_name,
        :primary_contact_last_name,
        :primary_contact_email,
        :primary_contact_phone_number,
        :primary_contact_title,
        :secondary_contact_first_name,
        :secondary_contact_last_name,
        :secondary_contact_email,
        :secondary_contact_phone_number,
        :secondary_contact_title,
        :phone_number,
        :url,
        :time_zone,
        time_zones: []
      ]
    )
  end
end
