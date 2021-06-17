require 'test_helper'

class QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get start" do
    get questions_start_url
    assert_response :success
  end

  test "should get show" do
    get questions_show_url
    assert_response :success
  end

  test "should get finish" do
    get questions_finish_url
    assert_response :success
  end

end
