require "test_helper"

class RequestorDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @requestor_detail = requestor_details(:one)
  end

  test "should get index" do
    get requestor_details_url
    assert_response :success
  end

  test "should get new" do
    get new_requestor_detail_url
    assert_response :success
  end

  test "should create requestor_detail" do
    assert_difference("RequestorDetail.count") do
      post requestor_details_url, params: { requestor_detail: {  } }
    end

    assert_redirected_to requestor_detail_url(RequestorDetail.last)
  end

  test "should show requestor_detail" do
    get requestor_detail_url(@requestor_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_requestor_detail_url(@requestor_detail)
    assert_response :success
  end

  test "should update requestor_detail" do
    patch requestor_detail_url(@requestor_detail), params: { requestor_detail: {  } }
    assert_redirected_to requestor_detail_url(@requestor_detail)
  end

  test "should destroy requestor_detail" do
    assert_difference("RequestorDetail.count", -1) do
      delete requestor_detail_url(@requestor_detail)
    end

    assert_redirected_to requestor_details_url
  end
end
