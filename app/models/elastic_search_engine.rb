require 'elasticsearch'

class ElasticSearchEngine

  def self.rebuild_each 
    log :rebuild_each
    
    Product.includes({:values => :product_values}).limit(ES_LIMIT_REBUILD).collect do |product|
      push_product product
    end
  end

  def self.rebuild_bulk(limit = ES_LIMIT_REBUILD)
    # Init
    operations = []
    log :rebuild_bulk

    # Read all products
    products = Product.limit(limit)
    product_ids = products.collect(&:id)
    log :rebuild_bulk, "product_ids: #{product_ids.inspect}"

    # Read properties values for those products, grouping by product_id
    pps = ProductProperty.where(product_id: product_ids).
      select('product_properties.*').
      select('IF(value_id, `values`.value, other) as fvalue').
      joins('LEFT JOIN `values` ON values.id = product_properties.value_id').
      group_by(&:product_id)
    log :rebuild_bulk, "read #{pps.map(&:count).sum} ProductProperties for #{pps.count} products"

    # Handle every product
    products.each do |product|
      # Build product fields
      fields = product.es_fields(pps[product.id])
     
      # Stack this top pending operations
      log :rebuild_bulk, "product:#{product.id} #{fields.inspect}"
      operations << { index: { _id: product.id, data: fields }}
    end

    # Submit update to ES
    client = Elasticsearch::Client.new log: false
    #return operations
    esreply = client.bulk index: 'items', type: 'bulkitem', refresh: false, body: operations
  end


  def self.push_product(product)
    log :push_product,  "(#{product.id})"

    # Read properties values for those products, grouping by product_id
    pps = ProductProperty.where(product_id: product.id).
      select('product_properties.*').
      select('IF(value_id, `values`.value, other) as fvalue').
      joins('LEFT JOIN `values` ON values.id = product_properties.value_id')
    log :rebuild_bulk, "read #{pps.count} ProductProperties for this product"

    # Build product fields
    fields = product.es_fields(pps)

    # Submit update to ES
    client = Elasticsearch::Client.new log: false
    log :push_product, "(#{product.id}) >> #{fields.inspect}"
    esreply = client.index index: 'items', type: 'item', id: product.id, body: fields

    log :push_product, "(#{product.id}) << #{esreply.inspect}"

    return esreply
  end

protected

  def self.log function, msg=nil
    #return unless DEBUG==true
    msg ||= "---------------------------------------------------"
    puts "#{function} | #{msg}" 
    #Rails.logger.info "#{method} | f#{function} | #{msg}" 
  end 

end