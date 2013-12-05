# encoding: utf-8

Attribute.create([
  { :name => "couleur", :created_at => "2013-12-05 15:14:06", :updated_at => "2013-12-05 15:14:06" },
  { :name => "taille", :created_at => "2013-12-05 15:14:32", :updated_at => "2013-12-05 15:14:32" },
  { :name => "boite", :created_at => "2013-12-05 15:14:49", :updated_at => "2013-12-05 15:57:32" },
  { :name => "matiere", :created_at => "2013-12-05 17:11:38", :updated_at => "2013-12-05 17:11:50" },
  { :name => "style", :created_at => "2013-12-05 21:51:20", :updated_at => "2013-12-05 21:51:20" }
], :without_protection => true )

Product.create([
  { :sku => "p1", :title => "Chaussure volante 2", :description => "desc2", :visibility => false, :attrs => "", :created_at => "2013-12-05 15:11:55", :updated_at => "2013-12-05 17:16:11" },
  { :sku => "p2", :title => "Cirages 2", :description => "random 382", :visibility => false, :attrs => "", :created_at => "2013-12-05 15:12:28", :updated_at => "2013-12-05 21:27:29" }
], :without_protection => true )

Value.create([
  { :attribute_id => 1, :value => "bleu", :created_at => "2013-12-05 15:20:22", :updated_at => "2013-12-05 15:20:22" },
  { :attribute_id => 1, :value => "vert", :created_at => "2013-12-05 15:21:04", :updated_at => "2013-12-05 15:21:04" },
  { :attribute_id => 1, :value => "blanc", :created_at => "2013-12-05 15:21:08", :updated_at => "2013-12-05 15:21:08" },
  { :attribute_id => 2, :value => "34", :created_at => "2013-12-05 15:21:13", :updated_at => "2013-12-05 15:21:13" },
  { :attribute_id => 2, :value => "42", :created_at => "2013-12-05 15:21:18", :updated_at => "2013-12-05 15:21:18" },
  { :attribute_id => 2, :value => "46", :created_at => "2013-12-05 15:21:23", :updated_at => "2013-12-05 15:21:23" },
  { :attribute_id => 3, :value => "carton", :created_at => "2013-12-05 16:00:34", :updated_at => "2013-12-05 16:00:34" },
  { :attribute_id => 3, :value => "metallique", :created_at => "2013-12-05 16:00:39", :updated_at => "2013-12-05 21:08:20" },
  { :attribute_id => 4, :value => "cuir", :created_at => "2013-12-05 17:11:55", :updated_at => "2013-12-05 17:11:55" },
  { :attribute_id => 4, :value => "toile", :created_at => "2013-12-05 17:12:01", :updated_at => "2013-12-05 17:12:01" },
  { :attribute_id => 5, :value => "moderne", :created_at => "2013-12-05 21:51:29", :updated_at => "2013-12-05 21:51:29" },
  { :attribute_id => 5, :value => "ringard", :created_at => "2013-12-05 21:51:34", :updated_at => "2013-12-05 21:51:34" }
], :without_protection => true )

ProductValue.create([
  { :product_id => 2, :value_id => 3 },
  { :product_id => 2, :value_id => 8 },
  { :product_id => 1, :value_id => 7 },
  { :product_id => 2, :value_id => 9 },
  { :product_id => 1, :value_id => 12 }
], :without_protection => true )
