class Property < ActiveRecord::Base
  attr_accessible :name
  has_many :products
  has_many :values
end
