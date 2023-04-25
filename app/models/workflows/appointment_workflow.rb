module Workflows
  module AppointmentWorkflow
    extend ActiveSupport::Concern

    CANCELLABLE_STATUSES = [
      "opened",
      "offered",
      "scheduled",
      "verified",
      "exported",
      "created"
    ].freeze

    def allowed_actions(scoped_statuses)
      Array.wrap(scoped_statuses).each_with_object([]) do |action, array|
        if current_status.to_sym.in?(action.keys)
          array << action[current_status.to_sym]
        end
      end
    end

    def cancel!
      appointment_statuses.create!(
        name: :cancelled,
        user_id: creator_id
      )
    end

    def open!
      appointment_statuses.create!(
        name: :opened,
        user_id: creator_id
      )
    end
  end
end
