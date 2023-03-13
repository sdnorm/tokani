# == Schema Information
#
# Table name: pay_rate_languages
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#  pay_rate_id :integer
#
require "test_helper"

class PayRateLanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
