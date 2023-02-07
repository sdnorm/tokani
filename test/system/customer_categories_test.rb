require "application_system_test_case"

class CustomerCategoriesTest < ApplicationSystemTestCase
  setup do
    @customer_category = customer_categories(:one)
  end

  test "visiting the index" do
    visit customer_categories_url
    assert_selector "h1", text: "Customer Categories"
  end

  test "creating a Customer category" do
    visit customer_categories_url
    click_on "New Customer Category"

    click_on "Create Customer category"

    assert_text "Customer category was successfully created"
    assert_selector "h1", text: "Customer Categories"
  end

  test "updating a Customer category" do
    visit customer_category_url(@customer_category)
    click_on "Edit", match: :first

    click_on "Update Customer category"

    assert_text "Customer category was successfully updated"
    assert_selector "h1", text: "Customer Categories"
  end

  test "destroying a Customer category" do
    visit edit_customer_category_url(@customer_category)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Customer category was successfully destroyed"
  end
end
