class ProductProperty < ActiveRecord::Base
  belongs_to :product
  belongs_to :property
  belongs_to :value
end
