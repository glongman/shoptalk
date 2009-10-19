CALLS = {} # expedient. Scale with memcached or equiv.
# could wedge calls into the http session metaphor, use the call-id as a session id, and then use
# either db, or memcached sessions. Something to look at.
require 'call_sessions'
ActionController::Base.send :include, CallSessionFilter