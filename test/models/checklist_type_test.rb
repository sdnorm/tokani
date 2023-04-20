# == Schema Information
#
# Table name: checklist_types
#
#  id                  :bigint           not null, primary key
#  format              :integer
#  is_active           :boolean          default(TRUE), not null
#  name                :string
#  requires_expiration :boolean
#  requires_upload     :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :uuid             not null
#
# Indexes
#
#  index_checklist_types_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class ChecklistTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
