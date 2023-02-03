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
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => accounts.id)
#
require "test_helper"

class RecipientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
