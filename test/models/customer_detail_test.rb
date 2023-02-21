# == Schema Information
#
# Table name: customer_details
#
#  id                     :bigint           not null, primary key
#  appointments_in_person :boolean          default(TRUE)
#  appointments_phone     :boolean          default(TRUE)
#  appointments_video     :boolean          default(TRUE)
#  contact_name           :string
#  email                  :string
#  fax                    :string
#  notes                  :text
#  phone                  :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  customer_category_id   :bigint           not null
#  customer_id            :uuid             not null
#
# Indexes
#
#  index_customer_details_on_customer_category_id  (customer_category_id)
#  index_customer_details_on_customer_id           (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_category_id => customer_categories.id)
#
require "test_helper"

class CustomerDetailTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
