module CallSessions
  class << self
    def begin_session_for(call_id, shopify_session, timezone)
       CALLS[call_id] = {:session => shopify_session, :timezone => timezone}
    end
    
    def end_session_for(call_id)
      CALLS.delete(call_id)
    end
  end
end


module CallSessionFilter
  def shopify_call_session
    if current_call_session
      begin
        ActiveResource::Base.site = current_call_session[:session].site
        Time.zone = current_call_session[:timezone]
        yield
      ensure 
        ActiveResource::Base.site = nil
        #Time.zone = nil # reset back to UTC
      end
    else            
      render :text => [
        {:name => :Speak, :phrase => "So sorry. Something has gone wrong. Please try again in a little while. Goodbye."},
        {:name => :Hangup, :url => hangup_url}
      ].to_json      
    end
  end
  
  def current_call_session
    CALLS[params[:call_id]] if params[:call_id]
  end
end

ActionController::Base.send :include, CallSessionFilter