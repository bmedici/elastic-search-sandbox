require 'elasticsearch'
ES_SOURCE = '_source'
ES_ID = '_id'
ES_TYPE = '_type'
ES_SCORE = '_score'
ES_STAMP = '_stamp'

class ApplicationController < ActionController::Base
  protect_from_forgery
end
