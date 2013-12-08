class AddIndexes < ActiveRecord::Migration

  def change
  	#add_index :values, :property_id
  	add_index :product_values, :product_id
  	add_index :product_values, :value_id
  	add_index :product_properties, :product_id
  	add_index :product_properties, :property_id
  	add_index :product_properties, :value_id
  end

end