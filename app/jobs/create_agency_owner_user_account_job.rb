class CreateAgencyOwnerUserAccountJob < ApplicationJob
  queue_as :default

  def perform(agency_id)
    Agency.find(agency_id).create_owner_account_from_primary_contact
  end
end
