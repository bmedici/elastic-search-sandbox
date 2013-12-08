class CreateProductProperties < ActiveRecord::Migration
  def change
  	create_table :product_properties, :id => false do |t|
        t.references :product
        t.references :property
        t.references :value
        t.string :other
    end
  	add_index :product_properties, :product_id
  	add_index :product_properties, :property_id
  	add_index :product_properties, :value_id
  end
end
