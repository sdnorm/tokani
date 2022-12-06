require "application_system_test_case"

class SitesTest < ApplicationSystemTestCase
  setup do
    @site = sites(:one)
  end

  test "visiting the index" do
    visit sites_url
    assert_selector "h1", text: "Sites"
  end

  # test "creating a Site" do
  #   visit sites_url
  #   click_on "New Site"

  #   check "Active" if @site.active
  #   fill_in "Address", with: @site.address
  #   fill_in "Backport", with: @site.backport_id
  #   fill_in "City", with: @site.city
  #   fill_in "Contact name", with: @site.contact_name
  #   fill_in "Contact phone", with: @site.contact_phone
  #   fill_in "Email", with: @site.email
  #   fill_in "Name", with: @site.name
  #   fill_in "Notes", with: @site.notes
  #   fill_in "State", with: @site.state
  #   fill_in "Zip code", with: @site.zip_code
  #   click_on "Create Site"

  #   assert_text "Site was successfully created"
  #   assert_selector "h1", text: "Sites"
  # end

  test "updating a Site" do
    visit site_url(@site)
    click_on "Edit", match: :first

    check "Active" if @site.active
    fill_in "Address", with: @site.address
    fill_in "Backport", with: @site.backport_id
    fill_in "City", with: @site.city
    fill_in "Contact name", with: @site.contact_name
    fill_in "Contact phone", with: @site.contact_phone
    fill_in "Email", with: @site.email
    fill_in "Name", with: @site.name
    fill_in "Notes", with: @site.notes
    fill_in "State", with: @site.state
    fill_in "Zip code", with: @site.zip_code
    click_on "Update Site"

    assert_text "Site was successfully updated"
    assert_selector "h1", text: "Sites"
  end

  test "destroying a Site" do
    visit edit_site_url(@site)
    click_on "Delete", match: :first
    click_on "Confirm"

    assert_text "Site was successfully destroyed"
  end
end
