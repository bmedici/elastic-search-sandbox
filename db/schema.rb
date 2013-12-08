# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131207174326) do

  create_table "product_properties", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "property_id"
    t.integer "value_id"
    t.string  "other"
  end

  add_index "product_properties", ["product_id"], :name => "index_product_properties_on_product_id"
  add_index "product_properties", ["property_id"], :name => "index_product_properties_on_property_id"
  add_index "product_properties", ["value_id"], :name => "index_product_properties_on_value_id"

  create_table "products", :force => true do |t|
    t.string   "sku"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "properties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "values", :force => true do |t|
    t.integer  "property_id"
    t.string   "value"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "values", ["property_id"], :name => "index_values_on_property_id"

end
