class CreateExampleAgencyDataJob < ApplicationJob
  queue_as :default

  def perform(agency_id)
    Agency.find(agency_id).create_example_agency_data
  end
end
