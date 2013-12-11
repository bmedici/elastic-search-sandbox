require 'elasticsearch'

class ElasticSearchEngine

  def self.rebuild(limit = ES_LIMIT_REBUILD)
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

    # Skip ES if no operations collected
    return if operations.size.zero?

    # Submit update to ES
    esreply = ES_CLIENT.bulk index: ES_INDEX, type: ES_TYPE, refresh: false, body: operations
  end


  def self.get_product(product_id)
    # Submit query to ES
    return ES_CLIENT.get_source index: ES_INDEX, type: ES_TYPE, id: product_id #rescue nil
  end
  
  def self.get_products(ids)
    # Submit query to ES
    reply = ES_CLIENT.mget index: ES_INDEX, type: ES_TYPE, body: { ids: ids }

    # If response is weird, just exit
    return [] if reply['docs'].nil?

    # Parse reply and keep only found products
    items = {}
    reply['docs'].each do |p|
      # If element was not found or caused error, just skip it
      next unless p[ES_EXISTS] != false && p[ES_ERROR].nil?

      # Extract ID from p
      id = p[ES_ID].to_i

      # Keep ES_SOURCE part of reply
      items[id] = p[ES_SOURCE]
    end

    return items
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
    log :push_product, "(#{product.id}) >> #{fields.inspect}"
    esreply = ES_CLIENT.index index: ES_INDEX, type: ES_TYPE, id: product.id, body: fields

    log :push_product, "(#{product.id}) << #{esreply.inspect}"

    return esreply
  end

  def self.listall(max)
    ES_CLIENT.search index: ES_INDEX, body: {}, size: max
  end

protected

  def self.log function, msg=nil
    return unless DEBUG==true
    msg ||= "---------------------------------------------------"
    puts "#{function} | #{msg}" 
  end 

end