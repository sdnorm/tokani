# == Schema Information
#
# Table name: providers
#
#  id            :uuid             not null, primary key
#  allow_email   :boolean
#  allow_text    :boolean
#  email         :string
#  first_name    :string
#  last_name     :string
#  primary_phone :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :uuid             not null
#  department_id :uuid
#  site_id       :uuid
#
# Indexes
#
#  index_providers_on_customer_id     (customer_id)
#  index_providers_on_department_id   (department_id)
#  index_providers_on_site_id         (site_id)
#  unique_provider_email_customer_id  (email,customer_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => accounts.id)
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (site_id => sites.id)
#
require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
