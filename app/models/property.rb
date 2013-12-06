class Property < ActiveRecord::Base
  has_many :values
  attr_accessible :name
end
