require File.dirname(__FILE__) + '/../test_helper'

class CallsControllerTest < ActionController::TestCase
  
  def setup
    ::CALLS.clear
    session = ShopifyAPI::Session.new('foobar.myshopify.com', 'tokenvalue')
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
    error_goodbye = [
      { 'name' => 'Speak', 'phrase' => "Invalid access code. Goodbye"},
      { 'name' => 'Hangup' }
    ]
    post 'new', :call_id => '3', :result => '9999'
    assert_response :success
    assert_not_nil @response.body
    assert_equal error_goodbye, JSON.parse(@response.body)
    assert_nil ::CALLS['3']
  end
  
  test "hangup" do
    ::CALLS['1'] = {:session => session}
    get 'hangup', :call_id => '1'
    assert_response :success
    assert_nil ::CALLS['1']
    
  end
  
  test "orders no orders" do
    response_hash = [
      {'name' => 'Speak', 'phrase' => 'I did not find any orders that were created today. Goodbye.'},
      {'name' => 'Hangup', 'url' => hangup_url}
    ]
    ::CALLS['1'] = {:session => session}
    Shop.stubs(:count_todays_orders).returns(0)
    get 'order_total', :call_id => '1'
    assert_response :success
    assert_equal response_hash, JSON.parse(@response.body)
  end
  
  test "orders has orders" do
    response_hash = [
      {'name' => 'Speak', 'phrase' => 'I found 2 orders that were created today. One moment please.'},
      {'name' => 'Include', 'url' => 'http://test.host/call/order.json?compute=yes'}
    ]
    ::CALLS['1'] = {:session => session}
    Shop.stubs(:count_todays_orders).returns(2)
    get 'order_total', :call_id => '1'
    assert_response :success
    assert_equal response_hash, JSON.parse(@response.body)
  end
  
  test "orders details" do
    response_hash = [
      {'name' => 'Speak', 'phrase' => "The total value for todays orders is 45.00. Goodbye."},
      {'name' => 'Hangup', 'url' => hangup_url}
    ]
    ::CALLS['1'] = {:session => session}
    Shop.stubs(:get_todays_orders).returns('45.00')
    get 'order_total', :call_id => '1', :compute => 'yes'
    assert_response :success
    assert_equal response_hash, JSON.parse(@response.body)
  end
end
