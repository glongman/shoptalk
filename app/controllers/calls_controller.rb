class CallsController < ApplicationController
  def index; response.headers['type'] = 'application/json' end #TODO mondo crappo
  def new; response.headers['type'] = 'application/json' end
  def create; end
  def destroy; end
  # no update
  # no show
end
