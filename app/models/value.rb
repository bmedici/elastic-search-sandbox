class Value < ActiveRecord::Base
  belongs_to :property
  has_many :product_values
  has_many :products, through: :product_values
  attr_accessible :value, :property_id
  after_save :es_update

  def es_update
    products.includes(:values).all.collect do |product|
      product.es_update
    end
  end

end
