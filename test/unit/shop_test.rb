require File.dirname(__FILE__) + '/../test_helper'

class ShopTest < ActiveSupport::TestCase
  
  test "login_finalized" do
    api_shop = ShopifyAPI::Shop.new
    api_shop.stubs(:name).returns('Foo Shop')
    api_shop.stubs(:timezone).returns('(GMT-05:00) Eastern Time (US & Canada)')
    ShopifyAPI::Shop.stubs(:current).returns(api_shop)
    session = ShopifyAPI::Session.new('foo.myshopify.com', 'tokenvalue')
    assert_difference 'Shop.count' do
      assert Shop.login_finalized session
    end
    shop = Shop.find_by_url 'foo.myshopify.com'
    assert_not_nil shop
    assert_equal 'tokenvalue', shop.token
    assert_not_nil shop.pin
    assert_equal 'Eastern Time (US & Canada)', shop.timezone
    assert_equal 'Foo Shop', shop.name
  end
  
  test "login_finalized had timeout but thats ok" do
    ShopifyAPI::Shop.stubs(:current).raises(Timeout::Error)
    session = ShopifyAPI::Session.new('foo.myshopify.com', 'tokenvalue')
    assert_difference 'Shop.count' do
      assert Shop.login_finalized session
    end
    shop = Shop.find_by_url 'foo.myshopify.com'
    assert_not_nil shop
    assert_equal 'tokenvalue', shop.token
    assert_not_nil shop.pin
    assert_nil shop.timezone
    assert_nil shop.name
  end
  
  test "login_finalized had connection reset but thats ok" do
    ShopifyAPI::Shop.stubs(:current).raises(Errno::ECONNRESET)
    session = ShopifyAPI::Session.new('foo.myshopify.com', 'tokenvalue')
    assert_difference 'Shop.count' do
      assert Shop.login_finalized session
    end
    shop = Shop.find_by_url 'foo.myshopify.com'
    assert_not_nil shop
    assert_equal 'tokenvalue', shop.token
    assert_not_nil shop.pin
    assert_nil shop.timezone
    assert_nil shop.name
  end
  
  test "todays orders ok" do
    # now this is a little funky. Normally Shop.todays_orders is called by controller method and
    # the ActiveResource::Base.site has already been set.
    # We could easily mimic that by making a ShopoifyAPI::Session and using this method in Shop, 
    # Shop.with_shopify_session
    # However, rather than doing that and having the test hit Shopify, we mock it all baby.
    
    
  end
  
  test "todays orders no orders" do
    
    
    
  end
  
  test "todays orders timed out" do
    
    
    
  end
  
  test "todays orders connection reset" do
    
    
    
  end
  
end
