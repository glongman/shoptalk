require 'net/http'
require 'uri'
class CallsController < ApplicationController
  
  def index
    render :text => [
      {:name => :Speak, :phrase => 'Welcome to ShopTalk. Enter your 4 digit access code.'},
      {:name => :GetDigits, :url => "#{new_call_url}.json", :max => 4},
      {:name => :playback, :filename => 'airport'},
      {:name => :playback, :filename => 'north-dakota'}
    ].to_json
  end 
  
  def new
    shop = Shop.find_by_pin params[result]
    if shop
      call_session = get_session_for shop, params[:call_id]
      if session.valid?
        
        render :text => [
        { :name => :Speak, :phrase => "You entered these digits. #{params[:result]}"},
        { :name => :Speak, :phrase => "You call id is. #{params[:call_id]}"},
        { :name => :Hangup }
        ].to_json
      else
        incorrect_and_goodbye
      end
    else
     incorrect_and_goodbye
    end
  end
  
  def create; end
  def destroy; end
  # no update
  # no show
  
  def get_session_for(shop, call_id)
    return CALLS[call_id][:session] if CALLS[call_id]
    permission_url = ShopifyAPI::Session.new(params[:shop].chomp('/')).create_permission_url
  rescue 
    log_error $!
  rescue Timeout::Error
    log_error $!  
  end
  
  # we expect only 1 redirect, to LoginController::finalize
  # that said, redirection handling here is not great if that assumption proves not to be true.
  # and these calls could hang for a long time.
  def fetch(uri_str, call_id=nil)

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
  
  def incorrect_and_goodbye
     render :text => [
      { :name => :Speak, :phrase => "Incorrect access code. Goodbye"},
      { :name => :Hangup }
      ].to_json
  end
end
