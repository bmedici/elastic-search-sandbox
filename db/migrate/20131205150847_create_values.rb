class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.references :attribute
      t.string :value

      t.timestamps
    end
    add_index :values, :attribute_id
  end
end
