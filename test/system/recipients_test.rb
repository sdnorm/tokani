require "application_system_test_case"

class RecipientsTest < ApplicationSystemTestCase
  # setup do
  #   @recipient = recipients(:one)
  # end

  # test "visiting the index" do
  #   visit recipients_url
  #   assert_selector "h1", text: "Recipients"
  # end

  # test "creating a Recipient" do
  #   visit recipients_url
  #   click_on "New Recipient"

  #   check "Allow email" if @recipient.allow_email
  #   check "Allow text" if @recipient.allow_text
  #   fill_in "Customer", with: @recipient.customer_id
  #   fill_in "Email", with: @recipient.email
  #   fill_in "First name", with: @recipient.first_name
  #   fill_in "Last name", with: @recipient.last_name
  #   fill_in "Mobile phone", with: @recipient.mobile_phone
  #   fill_in "Primary phone", with: @recipient.primary_phone
  #   fill_in "Srn", with: @recipient.srn
  #   click_on "Create Recipient"

  #   assert_text "Recipient was successfully created"
  #   assert_selector "h1", text: "Recipients"
  # end

  # test "updating a Recipient" do
  #   visit recipient_url(@recipient)
  #   click_on "Edit", match: :first

  #   check "Allow email" if @recipient.allow_email
  #   check "Allow text" if @recipient.allow_text
  #   fill_in "Customer", with: @recipient.customer_id
  #   fill_in "Email", with: @recipient.email
  #   fill_in "First name", with: @recipient.first_name
  #   fill_in "Last name", with: @recipient.last_name
  #   fill_in "Mobile phone", with: @recipient.mobile_phone
  #   fill_in "Primary phone", with: @recipient.primary_phone
  #   fill_in "Srn", with: @recipient.srn
  #   click_on "Update Recipient"

  #   assert_text "Recipient was successfully updated"
  #   assert_selector "h1", text: "Recipients"
  # end

  # test "destroying a Recipient" do
  #   visit edit_recipient_url(@recipient)
  #   click_on "Delete", match: :first
  #   click_on "Confirm"

  #   assert_text "Recipient was successfully destroyed"
  # end
end
