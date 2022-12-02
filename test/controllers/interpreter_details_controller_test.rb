require "test_helper"

class InterpreterDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interpreter_detail = interpreter_details(:one)
  end

  test "should get index" do
    get interpreter_details_url
    assert_response :success
  end

  # test "should get new" do
  #   get new_interpreter_detail_url
  #   assert_response :success
  # end

  test "should create interpreter_detail" do
    assert_difference("InterpreterDetail.count") do
      post interpreter_details_url, params: {interpreter_detail: {gender: @interpreter_detail.gender, interpreter_type: @interpreter_detail.interpreter_type, primary_phone: @interpreter_detail.primary_phone}}
    end

    assert_redirected_to interpreter_detail_url(InterpreterDetail.last)
  end

  test "should show interpreter_detail" do
    get interpreter_detail_url(@interpreter_detail)
    assert_response :success
  end

  # test "should get edit" do
  #   get edit_interpreter_detail_url(@interpreter_detail)
  #   assert_response :success
  # end

  test "should update interpreter_detail" do
    patch interpreter_detail_url(@interpreter_detail), params: {interpreter_detail: {gender: @interpreter_detail.gender, interpreter_type: @interpreter_detail.interpreter_type, primary_phone: @interpreter_detail.primary_phone}}
    assert_redirected_to interpreter_detail_url(@interpreter_detail)
  end

  test "should destroy interpreter_detail" do
    assert_difference("InterpreterDetail.count", -1) do
      delete interpreter_detail_url(@interpreter_detail)
    end

    assert_redirected_to interpreter_details_url
  end
end
