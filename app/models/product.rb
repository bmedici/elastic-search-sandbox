class Product < ActiveRecord::Base
  attr_accessible :description, :sku, :title

  has_many :product_properties
  has_many :properties, through: :product_properties
  has_many :values, through: :product_properties

  after_save :es_update

  def ping
    update_attribute(:description, 'random '+rand(1000).to_s)
  end

  def es_fields param1
      # Props can be a grouped array or a query result
      props = param1.to_a

      # Common and debug fields
      fields = {}
      fields[ES_STAMP] = self.updated_at.to_i
      fields[:title] = self.title
      fields[:description] = self.description[0..50]

      # Handle properties if any
      props.each do |pp|
        #puts "- #{pp.inspect}"
        fields["p#{pp.property_id}"] = pp[:fvalue]
      end

    return fields
  end

  def es_fetch_stamp
    es_product = ElasticSearchEngine.get_product(self.id)
    
    # If object not found in ES, just retunr nil
    return nil if es_product.nil?

    # Otherwise return stamp
    es_product[ES_STAMP]
  end

  def es_update
    ElasticSearchEngine.push_product(self)
  end

end
