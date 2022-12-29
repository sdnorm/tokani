# == Schema Information
#
# Table name: specialties
#
#  id           :bigint           not null, primary key
#  display_code :string
#  is_active    :boolean
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class SpecialtyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
