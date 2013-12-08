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
      #fields[:description] = self.description

      # Handle properties if any
      props.each do |pp|
        #puts "- #{pp.inspect}"
        fields["p#{pp.property_id}"] = pp[:fvalue]
      end

    return fields
  end

  def es_fetch
    # Submit update to ES
    client = Elasticsearch::Client.new log: true
    reply = client.get index: 'items', type: 'item', id: self.id rescue nil

    # If not found, return nil
    #return nil if reply['exists'] == false
    return reply
  end

  def es_fetch_stamp
    es = es_fetch
    
    # If object not found in ES, just retunr nil
    return nil if es.nil? || es[ES_SOURCE].nil?

    # Otherwise return stamp
    es[ES_SOURCE][ES_STAMP]
  end

  def es_update
    ElasticSearchEngine.push_product(self)
  end

end
