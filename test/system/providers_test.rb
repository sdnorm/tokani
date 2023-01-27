require "application_system_test_case"

class ProvidersTest < ApplicationSystemTestCase
  # setup do
  #   @provider = providers(:one)
  # end

  # test "visiting the index" do
  #   visit providers_url
  #   assert_selector "h1", text: "Providers"
  # end

  # test "creating a Provider" do
  #   visit providers_url
  #   click_on "New Provider"

  #   check "Allow email" if @provider.allow_email
  #   check "Allow text" if @provider.allow_text
  #   fill_in "Customer", with: @provider.customer_id
  #   fill_in "Department", with: @provider.department_id
  #   fill_in "Email", with: @provider.email
  #   fill_in "First name", with: @provider.first_name
  #   fill_in "Last name", with: @provider.last_name
  #   fill_in "Primary phone", with: @provider.primary_phone
  #   fill_in "Site", with: @provider.site_id
  #   click_on "Create Provider"

  #   assert_text "Provider was successfully created"
  #   assert_selector "h1", text: "Providers"
  # end

  # test "updating a Provider" do
  #   visit provider_url(@provider)
  #   click_on "Edit", match: :first

  #   check "Allow email" if @provider.allow_email
  #   check "Allow text" if @provider.allow_text
  #   fill_in "Customer", with: @provider.customer_id
  #   fill_in "Department", with: @provider.department_id
  #   fill_in "Email", with: @provider.email
  #   fill_in "First name", with: @provider.first_name
  #   fill_in "Last name", with: @provider.last_name
  #   fill_in "Primary phone", with: @provider.primary_phone
  #   fill_in "Site", with: @provider.site_id
  #   click_on "Update Provider"

  #   assert_text "Provider was successfully updated"
  #   assert_selector "h1", text: "Providers"
  # end

  # test "destroying a Provider" do
  #   visit edit_provider_url(@provider)
  #   click_on "Delete", match: :first
  #   click_on "Confirm"

  #   assert_text "Provider was successfully destroyed"
  # end
end
