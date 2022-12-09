# == Schema Information
#
# Table name: interpreter_details
#
#  id                      :bigint           not null, primary key
#  address                 :string
#  city                    :string
#  dob                     :date
#  drivers_license         :string
#  emergency_contact_name  :string
#  emergency_contact_phone :string
#  gender                  :integer
#  interpreter_type        :integer
#  primary_phone           :string
#  ssn                     :string
#  start_date              :date
#  state                   :string
#  zip                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  interpreter_id          :uuid
#
# Indexes
#
#  index_interpreter_details_on_interpreter_id  (interpreter_id)
#
class InterpreterDetail < ApplicationRecord
  encrypts :ssn

  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :interpreter_details, partial: "interpreter_details/index", locals: {interpreter_detail: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :interpreter_details, target: dom_id(self, :index) }

  belongs_to :interpreter, class_name: "User"

  enum interpreter_type: {staff: 1, independent_contractor: 2, agency: 3, volunteer: 4}
  enum gender: {unspecified: 0, male: 1, female: 2, non_binary: 3}, _suffix: "gender"

  validates :interpreter_type, presence: true
  validates :gender, presence: true
  validates :primary_phone, presence: true
end
