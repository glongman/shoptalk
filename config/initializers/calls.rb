CALLS = {}


module CallSessions
  
  class << self
    
    def get_session_for(shop, call_id)
     return CALLS[call_id][:session] if CALLS[call_id]
     CALLS[call_id] = {}
     permission_url = ShopifyAPI::Session.new(shop.chomp('/')).create_permission_url
     fetch permission_url, call_id
     CALLS[call_id][:session] if CALLS[call_id]
    end
    
    # we expect only 1 redirect, to LoginController::finalize
    # that said, redirection handling here is not great if that assumption proves not to be true.
    # and these calls could hang for a long time.
    def fetch(uri_str, call_id=nil)
      debugger
      response = Net::HTTP.get_response(URI.parse(uri_str))
      case response
      when Net::HTTPSuccess     then true # neato, the session should be in the CALLS hash now
      when Net::HTTPRedirection 
        debugger
        fetch(response['location'] + "&call_id=#{call_id}")
      else
        response.error!
      end
    end
  end
end