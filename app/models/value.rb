class Value < ActiveRecord::Base
  attr_accessible :value, :property_id

  belongs_to :property
  has_many :product_properties
  has_many :products, through: :product_properties

  after_save :es_update

  def es_update
    products.all.collect do |product|
      product.es_update
    end
  end

end
