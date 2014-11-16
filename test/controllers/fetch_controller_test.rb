require 'test_helper'

class FetchControllerTest < ActionController::TestCase
  test "should get artist" do
    get :artist
    assert_response :success
  end

  test "should get album" do
    get :album
    assert_response :success
  end

  test "should get track" do
    get :track
    assert_response :success
  end

  test "should get random" do
    get :random
    assert_response :success
  end

end
