require File.dirname(__FILE__) + '/../test_helper'

class CallsControllerTest < ActionController::TestCase
  ERROR_GOOBYE = [
    { 'name' => 'Speak', 'phrase' => "Invalid access code. Goodbye"},
    { 'name' => 'Hangup' }
  ]
   
  def setup
    ::CALLS.clear
  end

  test "test index" do
   get 'index'
   assert_response :success
  end
  
  test "new call valid pin EDT" do
    post 'new', :call_id => '1', :result => '1111'
    assert_response :success
    call_session_data = ::CALLS['1']
    assert_not_nil call_session_data
    assert_not_nil call_session_data[:session]
    assert_equal "Eastern Time (US & Canada)", call_session_data[:timezone]
  end
  
  test "new call valid pin Hawaii" do
    post 'new', :call_id => '2', :result => '2222'
    assert_response :success
    call_session_data = ::CALLS['2']
    assert_not_nil call_session_data
    assert_not_nil call_session_data[:session]
    assert_equal "Hawaii", call_session_data[:timezone]
  end
  
  test "new call invalid pin" do
    post 'new', :call_id => '3', :result => '9999'
    assert_response :success
    assert_not_nil @response.body
    assert_equal ERROR_GOOBYE, JSON.parse(@response.body)
    assert_nil ::CALLS['3']
  end
end
