# == Schema Information
#
# Table name: customer_details
#
#  id                     :bigint           not null, primary key
#  appointments_in_person :boolean          default(TRUE)
#  appointments_phone     :boolean          default(TRUE)
#  appointments_video     :boolean          default(TRUE)
#  contact_name           :string
#  email                  :string
#  fax                    :string
#  notes                  :text
#  phone                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  customer_category_id   :bigint           not null
#  customer_id            :uuid             not null
#
# Indexes
#
#  index_customer_details_on_customer_category_id  (customer_category_id)
#  index_customer_details_on_customer_id           (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_category_id => customer_categories.id)
#
class CustomerDetail < ApplicationRecord
  # Broadcast changes in realtime with Hotwire
  # after_create_commit  -> { broadcast_prepend_later_to :customer_details, partial: "customer_details/index", locals: { customer_detail: self } }
  # after_update_commit  -> { broadcast_replace_later_to self }
  # after_destroy_commit -> { broadcast_remove_to :customer_details, target: dom_id(self, :index) }

  belongs_to :customer_category
  belongs_to :customer, inverse_of: :customer_detail, optional: true

  validates_presence_of :contact_name, :email, :customer_category, :phone
  validates :email, email: {possible: true, allow_blank: true, message: "Email is invalid"}
  validates :phone, phone: {possible: true, allow_blank: true, message: "Phone number is invalid, please use 222-222-2222"}
end
