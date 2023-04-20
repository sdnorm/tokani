# == Schema Information
#
# Table name: time_offs
#
#  id             :bigint           not null, primary key
#  date_range     :tsrange
#  end_datetime   :datetime
#  reason         :string
#  start_datetime :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :uuid             not null
#
# Indexes
#
#  index_time_offs_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class TimeOffTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
