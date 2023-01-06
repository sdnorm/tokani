require "application_system_test_case"

class LanguagesTest < ApplicationSystemTestCase
  setup do
    @language = languages(:one)
  end

  test "visiting the index" do
    visit languages_url
    assert_selector "h1", text: "Languages"
  end

  test "creating a Language" do
    visit languages_url
    click_on "New Language"

    click_on "Create Language"

    assert_text "Language was successfully created"
    assert_selector "h1", text: "Languages"
  end

  test "updating a Language" do
    visit language_url(@language)
    click_on "Edit", match: :first

    click_on "Update Language"

    assert_text "Language was successfully updated"
    assert_selector "h1", text: "Languages"
  end

  test "destroying a Language" do
    visit edit_language_url(@language)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Language was successfully destroyed"
  end
end
