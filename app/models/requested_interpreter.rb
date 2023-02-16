# == Schema Information
#
# Table name: requested_interpreters
#
#  id             :bigint           not null, primary key
#  rejected       :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  appointment_id :bigint           not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_requested_interpreters_on_appointment_id  (appointment_id)
#  index_requested_interpreters_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (appointment_id => appointments.id)
#  fk_rails_...  (user_id => users.id)
#
class RequestedInterpreter < ApplicationRecord
  belongs_to :interpreter, class_name: "User", foreign_key: "user_id"
  belongs_to :appointment

  enum status: {accepted: 1, rejected: 2, pending: 0}
end
