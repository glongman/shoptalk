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
    render :text => [
    { :name => :Speak, :phrase => "You entered these digits. #{params[:result]}"},
    { :name => :Speak, :phrase => "You call id is. #{params[:call_id]}"},
    ].to_json
  end
  def create; end
  def destroy; end
  # no update
  # no show
end
