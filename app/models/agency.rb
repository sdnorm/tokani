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
class Agency < Account
  # Broadcast changes in realtime with Hotwire
  after_create_commit  -> { broadcast_prepend_later_to :agencies, partial: "agencies/index", locals: { agency: self } }
  after_update_commit  -> { broadcast_replace_later_to self }
  after_destroy_commit -> { broadcast_remove_to :agencies, target: dom_id(self, :index) }

  before_create :set_agency_flag

  private

  def set_agency_flag
    self.agency = true
  end
end
