class CallsController < ApplicationController
  
  around_filter :shopify_calls_session, :only => 'orders'
  
  def index
    render :text => [
      {:name => :Speak, :phrase => 'Welcome to ShopTalk. Enter your 4 digit access code.'},
      {:name => :GetDigits, :url => "#{new_call_url}.json", :max => 4}
    ].to_json
  end 
  
  def new
    call_session, timezone = Shop.session_timezone_for params[:result]
    if call_session && call_session.valid?
      CallSessions::begin_session_for params[:call_id], call_session, timezone
      render :text => [
        {:name => :Speak, :phrase => 'Thank you. One moment please.'},
        {:name => :Include, :url => "#{orders_url}.json", :max => 4}
      ].to_json
    else
      incorrect_and_goodbye
    end
  end
  
  def order_total
    unless params[:compute]
      order_count = Shop.count_todays_orders
      if Shop.count_todays_orders > 0
        render :text => [
          {:name => :Speak, :phrase => 'I found #{order_count} orders that were created today. One moment please.'},
          {:name => :Include, :url => "#{orders_url}.json?compute=yes", :max => 4}
        ].to_json
      else
        render :text => [
          {:name => :Speak, :phrase => 'I did not find any orders that were created today. Goodbye.'},
          { :name => :Hangup, :url => hangup_url}
        ].to_json
      end
    else
      total = Shop.get_todays_orders do |orders|
        orders.inject(BigDecimal.new('0')) {|result, o| result + o.total_price}.to_s
      end
      render :text => [
        {:name => :Speak, :phrase => 'The total value for todays orders is #{total}. Goodbye.'},
        { :name => :Hangup, :url => hangup_url}
      ].to_json
    end
  end
  
  def hangup
    CallSessions::end_session_for params[:call_id]
    render :status => :ok
  end
  
  protected
  
  def incorrect_and_goodbye
     render :text => [
      { :name => :Speak, :phrase => "Invalid access code. Goodbye"},
      { :name => :Hangup }
      ].to_json
  end
end
