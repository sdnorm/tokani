# == Schema Information
#
# Table name: recipients
#
#  id            :uuid             not null, primary key
#  allow_email   :boolean
#  allow_text    :boolean
#  email         :string
#  first_name    :string
#  last_name     :string
#  mobile_phone  :string
#  primary_phone :string
#  srn           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :uuid             not null
#
# Indexes
#
#  index_recipients_on_customer_id  (customer_id)
#  unique_email_customer_id         (email,customer_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => accounts.id)
#

class Recipient < ApplicationRecord
  belongs_to :customer
  has_many :appointments
  # Broadcast changes in realtime with Hotwire
  # after_create_commit -> { broadcast_prepend_later_to :recipients, partial: "recipients/index", locals: {recipient: self} }
  # after_update_commit -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :recipients, target: dom_id(self, :index) }

  validates :primary_phone, phone: {possible: true, allow_blank: false, message: "Phone number is invalid, please use format 222-222-2222"}
  validates :email, email: true
  validates :first_name, presence: {message: "field is required"}
  validates :last_name, presence: {message: "field is required"}
  validates :customer_id, presence: {message: "field is required"}

  validates_uniqueness_of :email, scope: :customer_id

  def view_name
    "#{first_name} #{last_name}"
  end
end
