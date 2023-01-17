# == Schema Information
#
# Table name: accounts
#
#  id                 :uuid             not null, primary key
#  agency             :boolean
#  customer           :boolean          default(FALSE)
#  domain             :string
#  extra_billing_info :text
#  is_active          :boolean          default(TRUE)
#  name               :string           not null
#  personal           :boolean          default(FALSE)
#  subdomain          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  owner_id           :uuid
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
  has_many :sites

  private

  def set_customer_flag
    self.customer = true
  end
end
