class Shop < ActiveRecord::Base
  
  validates_presence_of :url, :token, :pin
  validates_uniqueness_of :url, :pin
  
  before_validation_on_create :generate_pin
  
  def self.session_timezone_for(pin)
    shop = Shop.find_by_pin pin
    if shop
      [ShopifyAPI::Session.new(shop.url, shop.token), shop.timezone]
    end
  end
  
  def self.login_finalized(shopify_session)
    shop = Shop.find_by_url(shopify_session.url) || Shop.new(:url => shopify_session.url)
    shop.token = shopify_session.token
    begin
      with_shopify_session shopify_session do
        api_shop = ShopifyAPI::Shop.current
        shop.name = api_shop.name
        shop.timezone = $1 if api_shop.timezone =~ /\(GMT.+\) (.*)/
      end
    rescue Timeout::Error, Errno::ECONNRESET
      logger.warn "Shop.login_finalized - Unable to access the shop via the api: #{$!.to_s}"
    end
    shop.save
  end
  
  # assuming that ActiveRecord::Base.site is set either by 
  # shopify_session or shopify_call_session filters
  #
  # otherwise wrap calls here with Shop.with_shopify_session
  def self.count_todays_orders
    ShopifyAPI::Order.count(:created_at_min => Time.zone.now.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S"))
  end
  
  # assuming that ActiveRecord::Base.site is set either by 
  # shopify_session or shopify_call_session filters
  #
  # otherwise wrap calls here with Shop.with_shopify_session
  def self.get_todays_orders
    orders = ShopifyAPI::Order.find(:all, :params => {:created_at_min => Time.zone.now.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S")})
    if block_given?
      yield orders
    end
  end
  
  def self.with_shopify_session(shopify_session, timezone=nil)
    old_site = ActiveResource::Base.site
    ActiveResource::Base.site = shopify_session.site
    Time.zone = timezone
    yield
  ensure
    ActiveResource::Base.site = old_site
    Time.zone = nil
  end
  
  def generate_pin
    #TODO obviously this could loop 4ever if there are already max # of shops created that a 4 digit pin allows for.
    #TODO and it will get slower and slower as more and more shops are added.
    #TODO should avoid generating pins like 1111, 0000, or 4444
    # IDEA = could use a Bloom Filter to improve performance. http://en.wikipedia.org/wiki/Bloom_filter
    pin_to_set = nil
    begin
      pin_to_set = '%04d' % rand(9999)
    end until pin_to_set && Shop.find_by_pin(pin_to_set).nil?
    self.pin = pin_to_set
  end
end
