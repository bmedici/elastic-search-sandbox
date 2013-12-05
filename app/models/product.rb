require 'elasticsearch'

class Product < ActiveRecord::Base
  # include Tire::Model::Search
  # include Tire::Model::Callbacks

  attr_accessible :description, :sku, :title, :visibility
  has_many :product_values
  has_many :values, through: :product_values
  before_save :es_update

  # def initialize(attrs={})
  #   self.class.property "extra" unless self.class.property_types.keys.include? "extra"
  #   # set instance variable
  #   instance_variable_set("@extra", self.values.inspect) 
  #   self.values.each do |v|
  #     attrname = v.attribute.name
  #     attrvalue = v.value

  #     # call Tire's property method if it hasn't been set explicitly
  #     self.class.property attrname unless self.class.property_types.keys.include? attrname
  #     # set instance variable
  #     instance_variable_set("@#{attrname}", attrvalue) 
  #   end
  # end

  def self.rebuild
    Product.includes(:values).all.collect do |product|
      product.es_update
    end
  end

  def ping
    update_attribute(:description, 'random '+rand(1000).to_s)
  end

  def es_update
    puts "es_update (#{self.id}) ---------------------------------------------------"
    fields = {}
    attrs = []

    # Common fields
    fields[:title] = self.title
    fields[:description] = self.description

    # Attribute values
    values.includes(:attribute).all.each do |v|
      name = v.attribute.name
      fields["a_#{name}"] = v.value
      attrs << name
    end

    # Debug fields
    fields['TOUCHED'] = DateTime.now.to_f
    fields['ATTRIBUTES'] = attrs.join(', ')
    puts "es_update (#{self.id}) >> #{fields.inspect}"

    # Submit update to ES
    client = Elasticsearch::Client.new log: true
    esreply = client.index index: 'items', type: 'item', id: self.id, body: fields

    puts "es_update (#{self.id}) << #{esreply.inspect}"

    return esreply
  end

end