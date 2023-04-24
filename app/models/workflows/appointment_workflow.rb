module Workflows
  module AppointmentWorkflow
    extend ActiveSupport::Concern

    def cancel!
      appointment_statuses.create!(
        name: :cancelled,
        user_id: creator_id
      )
    end

    def can_cancel?
      return unless current_status == "cancelled"

      true
    end
  end
end
