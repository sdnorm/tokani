require "test_helper"

class SitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @site = sites(:one)
  end

  test "should get index" do
    get sites_url
    assert_response :success
  end

  test "should get new" do
    get new_site_url
    assert_response :success
  end

  # test "should create site" do
  #   assert_difference("Site.count") do
  #     post sites_url, params: { site: { active: @site.active, address: @site.address, backport_id: @site.backport_id, city: @site.city, contact_name: @site.contact_name, contact_phone: @site.contact_phone, email: @site.email, name: @site.name, notes: @site.notes, state: @site.state, zip_code: @site.zip_code } }
  #   end

  #   assert_redirected_to site_url(Site.last)
  # end

  test "should show site" do
    get site_url(@site)
    assert_response :success
  end

  test "should get edit" do
    get edit_site_url(@site)
    assert_response :success
  end

  test "should update site" do
    patch site_url(@site), params: { site: { active: @site.active, address: @site.address, backport_id: @site.backport_id, city: @site.city, contact_name: @site.contact_name, contact_phone: @site.contact_phone, email: @site.email, name: @site.name, notes: @site.notes, state: @site.state, zip_code: @site.zip_code } }
    assert_redirected_to site_url(@site)
  end

  test "should destroy site" do
    assert_difference("Site.count", -1) do
      delete site_url(@site)
    end

    assert_redirected_to sites_url
  end
end
