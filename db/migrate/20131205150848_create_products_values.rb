class CreateProductsValues < ActiveRecord::Migration
  def change
  	create_table :products_values, :id => false do |t|
        t.references :product
        t.references :value
    end
  end
end
