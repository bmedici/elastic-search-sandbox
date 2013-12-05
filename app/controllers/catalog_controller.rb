class CatalogController < ApplicationController

  def index
    client = Elasticsearch::Client.new log: true

    search = client.search index: 'items', body: {}

    @result = search['hits']['hits']
    @keys = @result.first[ES_SOURCE].keys

  end

end