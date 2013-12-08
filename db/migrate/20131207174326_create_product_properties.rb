class CreateProductProperties < ActiveRecord::Migration
  def change
  	create_table :product_properties, :id => false do |t|
        t.references :product
        t.references :property
        t.references :value
        t.string :other
    end
  end
end
