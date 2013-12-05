class Value < ActiveRecord::Base
  belongs_to :attribute
  has_many :product_value
  has_many :products, through: :product_value
  attr_accessible :value, :attribute_id
  after_save :es_update

  def es_update
    products.includes(:values).all.collect do |product|
      product.es_update
    end
  end

end