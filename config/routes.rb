Elastic::Application.routes.draw do
  resources :values
  resources :properties
  resources :products

  match 'catalog/' => 'catalog#browse', as: 'browse_catalog'
  match 'catalog/list' => 'catalog#list', as: 'list_catalog'
  match 'catalog/rebuild' => 'catalog#rebuild', as: "rebuild"
  match 'catalog/rebuild/each' => 'catalog#rebuild_each', as: "rebuild_each"
end