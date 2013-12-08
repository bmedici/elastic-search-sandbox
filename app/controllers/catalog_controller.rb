class CatalogController < ApplicationController

  def browse
    client = Elasticsearch::Client.new log: false

    search = client.search index: 'items', body: {}, size: ES_LIMIT_CATALOG
    @result = search['hits']['hits']
    @keys = @result.first[ES_SOURCE].keys
  end

  def list
    client = Elasticsearch::Client.new log: false

  	begin
      search = client.search index: 'items', body: {}, size: ES_LIMIT_TABLE
    rescue Exception => e
      flash[:error]= "EXCEPTION #{e.class}"
    else
      @result = search['hits']['hits'] rescue []
      @keys = @result.map{ |r| r[ES_SOURCE].keys }.flatten.uniq rescue []
    end
    @result ||= []
    @keys ||= []

    # Info message
    flash[:notice] = "Retrieved #{@result.size} items (limited to #{ES_LIMIT_TABLE})"
  end

  def rebuild
    @reply = ElasticSearchEngine.rebuild_bulk
    #render text: "<pre>#{reply.to_yaml}</pre>" and return
    #redirect_to products_path, notice: "Index rebuilt for #{reply.size} entries"
  end

  def rebuild_each
    reply = ElasticSearchEngine.rebuild_each
    #render :text => reply.collect{ |u| u["_id"] } and return
    redirect_to products_path, notice: "Index rebuilt for #{reply.size} entries"
  end

end