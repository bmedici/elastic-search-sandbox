require 'elasticsearch'
ES_SOURCE = '_source'
ES_ID = '_id'
ES_TYPE = '_type'
ES_SCORE = '_score'

class ApplicationController < ActionController::Base
  protect_from_forgery
end
