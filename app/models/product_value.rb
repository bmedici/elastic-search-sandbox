class ProductValue < ActiveRecord::Base
  belongs_to :product
  belongs_to :value
end
