require "application_system_test_case"

class PayBillConfigsTest < ApplicationSystemTestCase
  setup do
    @pay_bill_config = pay_bill_configs(:one)
  end

  test "visiting the index" do
    visit pay_bill_configs_url
    assert_selector "h1", text: "Pay Bill Configs"
  end

  test "creating a Pay bill config" do
    visit pay_bill_configs_url
    click_on "New Pay Bill Config"

    fill_in "Account", with: @pay_bill_config.account_id
    fill_in "Afterhours availability end seconds1", with: @pay_bill_config.afterhours_availability_end_seconds1
    fill_in "Afterhours availability end seconds2", with: @pay_bill_config.afterhours_availability_end_seconds2
    fill_in "Afterhours availability start seconds1", with: @pay_bill_config.afterhours_availability_start_seconds1
    fill_in "Afterhours availability start seconds2", with: @pay_bill_config.afterhours_availability_start_seconds2
    fill_in "Billing increment", with: @pay_bill_config.billing_increment
    fill_in "Fixed roundtrip mileage", with: @pay_bill_config.fixed_roundtrip_mileage
    check "Is minutes billed appointment duration" if @pay_bill_config.is_minutes_billed_appointment_duration
    check "Is minutes billed cancelled appointment duration" if @pay_bill_config.is_minutes_billed_cancelled_appointment_duration
    fill_in "Maximum mileage", with: @pay_bill_config.maximum_mileage
    fill_in "Maximum travel time", with: @pay_bill_config.maximum_travel_time
    fill_in "Minimum minutes billed", with: @pay_bill_config.minimum_minutes_billed
    fill_in "Minimum minutes billed cancelled level 1", with: @pay_bill_config.minimum_minutes_billed_cancelled_level_1
    fill_in "Minimum minutes billed cancelled level 2", with: @pay_bill_config.minimum_minutes_billed_cancelled_level_2
    fill_in "Minimum minutes paid", with: @pay_bill_config.minimum_minutes_paid
    fill_in "Minimum minutes paid cancelled level 1", with: @pay_bill_config.minimum_minutes_paid_cancelled_level_1
    fill_in "Minimum minutes paid cancelled level 2", with: @pay_bill_config.minimum_minutes_paid_cancelled_level_2
    fill_in "Name", with: @pay_bill_config.name
    fill_in "Trigger for billing increment", with: @pay_bill_config.trigger_for_billing_increment
    fill_in "Trigger for cancel-level2", with: @pay_bill_config.trigger_for_cancel - level2
    fill_in "Trigger for cancel level1", with: @pay_bill_config.trigger_for_cancel_level1
    fill_in "Trigger for discount rate", with: @pay_bill_config.trigger_for_discount_rate
    fill_in "Trigger for mileage", with: @pay_bill_config.trigger_for_mileage
    fill_in "Trigger for rush rate", with: @pay_bill_config.trigger_for_rush_rate
    fill_in "Trigger for travel time", with: @pay_bill_config.trigger_for_travel_time
    fill_in "Weekend availability end seconds1", with: @pay_bill_config.weekend_availability_end_seconds1
    fill_in "Weekend availability end seconds2", with: @pay_bill_config.weekend_availability_end_seconds2
    fill_in "Weekend availability start seconds1", with: @pay_bill_config.weekend_availability_start_seconds1
    fill_in "Weekend availability start seconds2", with: @pay_bill_config.weekend_availability_start_seconds2
    click_on "Create Pay bill config"

    assert_text "Pay bill config was successfully created"
    assert_selector "h1", text: "Pay Bill Configs"
  end

  test "updating a Pay bill config" do
    visit pay_bill_config_url(@pay_bill_config)
    click_on "Edit", match: :first

    fill_in "Account", with: @pay_bill_config.account_id
    fill_in "Afterhours availability end seconds1", with: @pay_bill_config.afterhours_availability_end_seconds1
    fill_in "Afterhours availability end seconds2", with: @pay_bill_config.afterhours_availability_end_seconds2
    fill_in "Afterhours availability start seconds1", with: @pay_bill_config.afterhours_availability_start_seconds1
    fill_in "Afterhours availability start seconds2", with: @pay_bill_config.afterhours_availability_start_seconds2
    fill_in "Billing increment", with: @pay_bill_config.billing_increment
    fill_in "Fixed roundtrip mileage", with: @pay_bill_config.fixed_roundtrip_mileage
    check "Is minutes billed appointment duration" if @pay_bill_config.is_minutes_billed_appointment_duration
    check "Is minutes billed cancelled appointment duration" if @pay_bill_config.is_minutes_billed_cancelled_appointment_duration
    fill_in "Maximum mileage", with: @pay_bill_config.maximum_mileage
    fill_in "Maximum travel time", with: @pay_bill_config.maximum_travel_time
    fill_in "Minimum minutes billed", with: @pay_bill_config.minimum_minutes_billed
    fill_in "Minimum minutes billed cancelled level 1", with: @pay_bill_config.minimum_minutes_billed_cancelled_level_1
    fill_in "Minimum minutes billed cancelled level 2", with: @pay_bill_config.minimum_minutes_billed_cancelled_level_2
    fill_in "Minimum minutes paid", with: @pay_bill_config.minimum_minutes_paid
    fill_in "Minimum minutes paid cancelled level 1", with: @pay_bill_config.minimum_minutes_paid_cancelled_level_1
    fill_in "Minimum minutes paid cancelled level 2", with: @pay_bill_config.minimum_minutes_paid_cancelled_level_2
    fill_in "Name", with: @pay_bill_config.name
    fill_in "Trigger for billing increment", with: @pay_bill_config.trigger_for_billing_increment
    fill_in "Trigger for cancel-level2", with: @pay_bill_config.trigger_for_cancel - level2
    fill_in "Trigger for cancel level1", with: @pay_bill_config.trigger_for_cancel_level1
    fill_in "Trigger for discount rate", with: @pay_bill_config.trigger_for_discount_rate
    fill_in "Trigger for mileage", with: @pay_bill_config.trigger_for_mileage
    fill_in "Trigger for rush rate", with: @pay_bill_config.trigger_for_rush_rate
    fill_in "Trigger for travel time", with: @pay_bill_config.trigger_for_travel_time
    fill_in "Weekend availability end seconds1", with: @pay_bill_config.weekend_availability_end_seconds1
    fill_in "Weekend availability end seconds2", with: @pay_bill_config.weekend_availability_end_seconds2
    fill_in "Weekend availability start seconds1", with: @pay_bill_config.weekend_availability_start_seconds1
    fill_in "Weekend availability start seconds2", with: @pay_bill_config.weekend_availability_start_seconds2
    click_on "Update Pay bill config"

    assert_text "Pay bill config was successfully updated"
    assert_selector "h1", text: "Pay Bill Configs"
  end

  test "destroying a Pay bill config" do
    visit edit_pay_bill_config_url(@pay_bill_config)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Pay bill config was successfully destroyed"
  end
end
