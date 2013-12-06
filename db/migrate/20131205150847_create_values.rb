class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.references :property
      t.string :value

      t.timestamps
    end
    add_index :values, :property_id
  end
end
