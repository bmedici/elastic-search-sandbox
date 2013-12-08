class ProductProperty < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :product
  belongs_to :property
  belongs_to :value
end
