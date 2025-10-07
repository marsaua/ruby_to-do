require "test_helper"

class TestNewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get test_new_index_path
    assert_response :success
  end

  test "should get new" do
    get test_new_new_path
    assert_response :success
  end
end
