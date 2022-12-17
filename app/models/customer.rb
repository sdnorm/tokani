# == Schema Information
#
# Table name: accounts
#
#  id                     :uuid             not null, primary key
#  address                :string
#  appointments_in_person :boolean          default(TRUE)
#  appointments_phone     :boolean          default(TRUE)
#  appointments_video     :boolean          default(TRUE)
#  city                   :string
#  contact_name           :string
#  customer               :boolean          default(FALSE)
#  domain                 :string
#  email                  :string
#  extra_billing_info     :text
#  fax                    :string
#  is_active              :boolean          default(TRUE)
#  name                   :string           not null
#  notes                  :text
#  personal               :boolean          default(FALSE)
#  phone                  :string
#  state                  :string
#  subdomain              :string
#  zip                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  owner_id               :uuid
#
# Indexes
#
#  index_accounts_on_created_at  (created_at)
#  index_accounts_on_owner_id    (owner_id)
#
class Customer < Account
  # Broadcast changes in realtime with Hotwire
  after_create_commit -> { broadcast_prepend_later_to :customers, partial: "customers/index", locals: {customer: self} }
  after_update_commit -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :customers, target: dom_id(self, :index) }

  before_create :set_customer_flag

  private

  def set_customer_flag
    self.customer = true
  end
end
