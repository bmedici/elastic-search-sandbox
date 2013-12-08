class CreateProductValues < ActiveRecord::Migration
  def change
  	create_table :product_values, :id => false do |t|
        t.references :product
        t.references :value
	  	t.string :value
    end
  	add_index :product_values, :product_id
  	add_index :product_values, :value_id
  end
end
