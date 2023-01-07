require "application_system_test_case"

class PayBillRatesTest < ApplicationSystemTestCase
  setup do
    @pay_bill_rate = pay_bill_rates(:one)
  end

  test "visiting the index" do
    visit pay_bill_rates_url
    assert_selector "h1", text: "Pay Bill Rates"
  end

  test "creating a Pay bill rate" do
    visit pay_bill_rates_url
    click_on "New Pay Bill Rate"

    fill_in "Account", with: @pay_bill_rate.account_id
    fill_in "After hours bill rate", with: @pay_bill_rate.after_hours_bill_rate
    fill_in "After hours pay rate", with: @pay_bill_rate.after_hours_pay_rate
    fill_in "Bill rate", with: @pay_bill_rate.bill_rate
    fill_in "Cancel level 1 bill rate", with: @pay_bill_rate.cancel_level_1_bill_rate
    fill_in "Cancel level 1 pay rate", with: @pay_bill_rate.cancel_level_1_pay_rate
    fill_in "Cancel level 2 bill rate", with: @pay_bill_rate.cancel_level_2_bill_rate
    fill_in "Cancel level 2 pay rate", with: @pay_bill_rate.cancel_level_2_pay_rate
    fill_in "Discount bill rate", with: @pay_bill_rate.discount_bill_rate
    fill_in "Discount pay rate", with: @pay_bill_rate.discount_pay_rate
    fill_in "Effective date", with: @pay_bill_rate.effective_date
    check "In person" if @pay_bill_rate.in_person
    fill_in "Interpreter types", with: @pay_bill_rate.interpreter_types
    check "Is active" if @pay_bill_rate.is_active
    check "Is default" if @pay_bill_rate.is_default
    fill_in "Mileage rate", with: @pay_bill_rate.mileage_rate
    fill_in "Name", with: @pay_bill_rate.name
    fill_in "Pay rate", with: @pay_bill_rate.pay_rate
    check "Phone" if @pay_bill_rate.phone
    fill_in "Rush bill rate", with: @pay_bill_rate.rush_bill_rate
    fill_in "Rush pay rate", with: @pay_bill_rate.rush_pay_rate
    fill_in "Travel time rate", with: @pay_bill_rate.travel_time_rate
    check "Video" if @pay_bill_rate.video
    click_on "Create Pay bill rate"

    assert_text "Pay bill rate was successfully created"
    assert_selector "h1", text: "Pay Bill Rates"
  end

  test "updating a Pay bill rate" do
    visit pay_bill_rate_url(@pay_bill_rate)
    click_on "Edit", match: :first

    fill_in "Account", with: @pay_bill_rate.account_id
    fill_in "After hours bill rate", with: @pay_bill_rate.after_hours_bill_rate
    fill_in "After hours pay rate", with: @pay_bill_rate.after_hours_pay_rate
    fill_in "Bill rate", with: @pay_bill_rate.bill_rate
    fill_in "Cancel level 1 bill rate", with: @pay_bill_rate.cancel_level_1_bill_rate
    fill_in "Cancel level 1 pay rate", with: @pay_bill_rate.cancel_level_1_pay_rate
    fill_in "Cancel level 2 bill rate", with: @pay_bill_rate.cancel_level_2_bill_rate
    fill_in "Cancel level 2 pay rate", with: @pay_bill_rate.cancel_level_2_pay_rate
    fill_in "Discount bill rate", with: @pay_bill_rate.discount_bill_rate
    fill_in "Discount pay rate", with: @pay_bill_rate.discount_pay_rate
    fill_in "Effective date", with: @pay_bill_rate.effective_date
    check "In person" if @pay_bill_rate.in_person
    fill_in "Interpreter types", with: @pay_bill_rate.interpreter_types
    check "Is active" if @pay_bill_rate.is_active
    check "Is default" if @pay_bill_rate.is_default
    fill_in "Mileage rate", with: @pay_bill_rate.mileage_rate
    fill_in "Name", with: @pay_bill_rate.name
    fill_in "Pay rate", with: @pay_bill_rate.pay_rate
    check "Phone" if @pay_bill_rate.phone
    fill_in "Rush bill rate", with: @pay_bill_rate.rush_bill_rate
    fill_in "Rush pay rate", with: @pay_bill_rate.rush_pay_rate
    fill_in "Travel time rate", with: @pay_bill_rate.travel_time_rate
    check "Video" if @pay_bill_rate.video
    click_on "Update Pay bill rate"

    assert_text "Pay bill rate was successfully updated"
    assert_selector "h1", text: "Pay Bill Rates"
  end

  test "destroying a Pay bill rate" do
    visit edit_pay_bill_rate_url(@pay_bill_rate)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Pay bill rate was successfully destroyed"
  end
end
