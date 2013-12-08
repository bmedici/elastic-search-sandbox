class Value < ActiveRecord::Base
  attr_accessible :value, :property_id

  belongs_to :property
  has_many :product_values
  has_many :products, through: :product_values

  after_save :es_update

  def es_update
    products.includes(:values).all.collect do |product|
      product.es_update
    end
  end

end
