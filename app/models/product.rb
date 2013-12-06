require 'elasticsearch'
class Product < ActiveRecord::Base

  attr_accessible :description, :sku, :title
  has_many :product_values
  has_many :values, through: :product_values
  after_save :es_update

  def self.rebuild
    Product.includes(:values).all.collect do |product|
      product.es_update
    end
  end

  def ping
    update_attribute(:description, 'random '+rand(1000).to_s)
  end

  def es_fetch
    # Submit update to ES
    client = Elasticsearch::Client.new log: true
    client.get index: 'items', type: 'item', id: self.id
  end

  def es_fetch_stamp
    es = es_fetch
    es[ES_SOURCE][ES_STAMP]
  end

  def es_update
    puts "es_update (#{self.id}) ---------------------------------------------------"
    fields = {}
    attrs = []

    # Common fields
    fields[:title] = self.title
    fields[:description] = self.description

    # Initialize properties values with NIL
    Property.order(:name).all do |prop|
      fields["a_#{prop.name}"] = nil
    end

    # Set the current value if found
    attrs = values.includes(:property).all.each do |v|
      name = v.property.name
      fields["a_#{name}"] = v.value
      attrs << name
    end

    # Debug fields
    fields[ES_STAMP] = self.updated_at.to_i
    fields[ES_ATTR] = attrs.join(', ')
    #fields[ES_DEBUG] = names.inspect
    puts "es_update (#{self.id}) >> #{fields.inspect}"

    # Submit update to ES
    client = Elasticsearch::Client.new log: true
    esreply = client.index index: 'items', type: 'item', id: self.id, body: fields

    puts "es_update (#{self.id}) << #{esreply.inspect}"

    return esreply
  end

end