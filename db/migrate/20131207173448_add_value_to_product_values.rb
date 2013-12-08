class AddValueToProductValues < ActiveRecord::Migration
  def change
  	add_column :product_values, :value, :string
  end
end
