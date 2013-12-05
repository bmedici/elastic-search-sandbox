class CreateProductValues < ActiveRecord::Migration
  def change
  	create_table :product_values, :id => false do |t|
        t.references :product
        t.references :value
    end
  end
end
