class CatalogController < ApplicationController

  def browse
    client = Elasticsearch::Client.new log: true

    search = client.search index: 'items', body: {}, size: ES_LIMIT_CATALOG
    @result = search['hits']['hits']
    @keys = @result.first[ES_SOURCE].keys
  end

  def list
    client = Elasticsearch::Client.new log: true

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
  end


  def rebuild
    reply = Product.rebuild
    #render :text => reply.collect{ |u| u["_id"] } and return
    redirect_to products_path, notice: "Index rebuilt for #{reply.size} entries"
  end

end