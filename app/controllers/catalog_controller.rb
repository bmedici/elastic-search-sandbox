class CatalogController < ApplicationController

  def browse
    search = ElasticSearchEngine.listall(ES_LIMIT_CATALOG)
    @result = search['hits']['hits']
    @keys = @result.first[ES_SOURCE].keys
  end

  def list
  	begin
      search = ElasticSearchEngine.listall(ES_LIMIT_TABLE)
    rescue Exception => e
      flash[:error]= "EXCEPTION #{e.class}"
    else
      @result = search['hits']['hits'] rescue []
      @keys = @result.map{ |r| r[ES_SOURCE].keys }.flatten.uniq rescue []
    end
    @result ||= []
    @keys ||= []

    # Info message
    flash[:notice] = "Retrieved #{@result.size} #{ES_INDEX} (limited to #{ES_LIMIT_TABLE})"
  end

  def rebuild
    d1 = DateTime.now.to_f
    @reply = ElasticSearchEngine.rebuild
    d2 = DateTime.now.to_f
    time = (d2 - d1)
    flash[:notice]= "Rebuild took #{time.round(2)} seconds"
  end

end