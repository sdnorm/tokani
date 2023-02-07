require "test_helper"

class CustomerCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @customer_category = customer_categories(:one)
  end

  test "should get index" do
    get customer_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_customer_category_url
    assert_response :success
  end

  test "should create customer_category" do
    assert_difference("CustomerCategory.count") do
      post customer_categories_url, params: { customer_category: {  } }
    end

    assert_redirected_to customer_category_url(CustomerCategory.last)
  end

  test "should show customer_category" do
    get customer_category_url(@customer_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_customer_category_url(@customer_category)
    assert_response :success
  end

  test "should update customer_category" do
    patch customer_category_url(@customer_category), params: { customer_category: {  } }
    assert_redirected_to customer_category_url(@customer_category)
  end

  test "should destroy customer_category" do
    assert_difference("CustomerCategory.count", -1) do
      delete customer_category_url(@customer_category)
    end

    assert_redirected_to customer_categories_url
  end
end
