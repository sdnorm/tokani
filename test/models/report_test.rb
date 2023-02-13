# == Schema Information
#
# Table name: reports
#
#  id                   :bigint           not null, primary key
#  date_begin           :date
#  date_end             :date
#  fields_to_show       :string
#  in_person            :boolean
#  interpreter_type     :string
#  phone                :boolean
#  report_type          :integer
#  video                :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  account_id           :uuid
#  customer_category_id :integer
#  customer_id          :uuid
#  department_id        :uuid
#  interpreter_id       :uuid
#  language_id          :integer
#  site_id              :uuid
#
require "test_helper"

class ReportTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
