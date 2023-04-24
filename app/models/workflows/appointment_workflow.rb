module Workflows
  module AppointmentWorkflow
    extend ActiveSupport::Concern

    def allowed_actions(scoped_statuses)
      scoped_statuses.each_with_object([]) do |action, array|
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

    def can_cancel?
      return unless current_status == "cancelled"

      true
    end

    def open!
      appointment_statuses.create!(
        name: :opened,
        user_id: creator_id
      )
    end

    def can_open?
      return unless current_status == "opened"

      true
    end
  end
end
