class Value < ActiveRecord::Base
  attr_accessible :value, :property_id

  belongs_to :property

  after_save :es_update

  def es_update
    products.all.collect do |product|
      product.es_update
    end
  end

end
