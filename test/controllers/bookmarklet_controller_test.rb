require 'test_helper'

class BookmarkletControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
