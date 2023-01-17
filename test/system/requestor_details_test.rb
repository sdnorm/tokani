require "application_system_test_case"

class RequestorDetailsTest < ApplicationSystemTestCase
  setup do
    @requestor_detail = requestor_details(:one)
  end

  test "visiting the index" do
    visit requestor_details_url
    assert_selector "h1", text: "Requestor Details"
  end

  test "creating a Requestor detail" do
    visit requestor_details_url
    click_on "New Requestor Detail"

    click_on "Create Requestor detail"

    assert_text "Requestor detail was successfully created"
    assert_selector "h1", text: "Requestor Details"
  end

  test "updating a Requestor detail" do
    visit requestor_detail_url(@requestor_detail)
    click_on "Edit", match: :first

    click_on "Update Requestor detail"

    assert_text "Requestor detail was successfully updated"
    assert_selector "h1", text: "Requestor Details"
  end

  test "destroying a Requestor detail" do
    visit edit_requestor_detail_url(@requestor_detail)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Requestor detail was successfully destroyed"
  end
end
