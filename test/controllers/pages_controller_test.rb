require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get archer_armstrong" do
    get :archer_armstrong
    assert_response :success
  end

end
