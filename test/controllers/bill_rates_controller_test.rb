require "test_helper"

class BillRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bill_rate = bill_rates(:one)
  end
end
