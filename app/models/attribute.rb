class Attribute < ActiveRecord::Base
  has_many :values
  attr_accessible :name
end
