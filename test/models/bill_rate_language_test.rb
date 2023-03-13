# == Schema Information
#
# Table name: bill_rate_languages
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bill_rate_id :integer
#  language_id  :integer
#
require "test_helper"

class BillRateLanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
