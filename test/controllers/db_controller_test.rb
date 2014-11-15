require 'test_helper'

class DbControllerTest < ActionController::TestCase
  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get clean" do
    get :clean
    assert_response :success
  end

  test "should not get invalid" do
    get :invalid
    assert_response :failure
  end

end
