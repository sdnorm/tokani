require "application_system_test_case"

class ChecklistTypesTest < ApplicationSystemTestCase
  setup do
    @checklist_type = checklist_types(:one)
  end

  test "visiting the index" do
    visit checklist_types_url
    assert_selector "h1", text: "Checklist Types"
  end

  test "creating a Checklist type" do
    visit checklist_types_url
    click_on "New Checklist Type"

    click_on "Create Checklist type"

    assert_text "Checklist type was successfully created"
    assert_selector "h1", text: "Checklist Types"
  end

  test "updating a Checklist type" do
    visit checklist_type_url(@checklist_type)
    click_on "Edit", match: :first

    click_on "Update Checklist type"

    assert_text "Checklist type was successfully updated"
    assert_selector "h1", text: "Checklist Types"
  end

  test "destroying a Checklist type" do
    visit edit_checklist_type_url(@checklist_type)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Checklist type was successfully destroyed"
  end
end
