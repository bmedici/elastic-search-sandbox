class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku
      t.string :title
      t.text :description
      t.boolean :visibility
      t.text :attrs

      t.timestamps
    end
  end
end
