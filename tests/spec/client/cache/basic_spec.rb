require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

context Restfulie::Client::Cache::Basic do
  
  before do
    @response = Net::HTTPResponse
  end
  
  it "should put on the cache if Cache-Control is enabled" do
    url = Object.new
    request = Object.new
    cache = Restfulie::Client::Cache::Basic.new
    @response.should_receive(:vary_headers_for).with(request).and_return(1)
    @response.should_receive(:vary_headers_for).with(request).and_return(1)
    @response.should_receive(:method).and_return(:get)
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(@response).and_return(true)
    
    cache.put(url, request, @response)
    @response.should_receive(:has_expired_cache?).and_return(false)
    cache.get(url, request, :get).should == @response
  end

  it "should respect the vary header" do
    url = Object.new
    request = Object.new
    cache = Restfulie::Client::Cache::Basic.new
    @response.should_receive(:vary_headers_for).with(request).and_return(1)
    @response.should_receive(:vary_headers_for).with(request).and_return(2)
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(@response).and_return(true)
    
    cache.put(url, request, @response)
    cache.get(url, request, :get).should be_nil
  end

  it "should not put on the cache if Cache-Control is enabled" do
    url = Object.new
    request = Object.new
    cache = Restfulie::Client::Cache::Basic.new
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(@response).and_return(false)
    
    cache.put(url, request, @response)
    cache.get(url, request, :get).should be_nil
  end

  it "should remove from cache if expired" do
    url = Object.new
    request = Object.new
    cache = Restfulie::Client::Cache::Basic.new
    @response.should_receive(:vary_headers_for).with(request).and_return(1)
    @response.should_receive(:vary_headers_for).with(request).and_return(1)
    @response.stub(:method).and_return(:get)
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(@response).and_return(true)
    
    cache.put(url, request, @response)
    @response.should_receive(:has_expired_cache?).and_return(true)
    cache.get(url, request, :get).should be_nil
  end

  it "should allow cache clean up" do
    url = Object.new
    request = Object.new
    cache = Restfulie::Client::Cache::Basic.new
    
    Restfulie::Client::Cache::Restrictions.should_receive(:may_cache?).with(@response).and_return(true)
    
    cache.put(url, request, @response)
    cache.clear
    cache.get(url, request, :get).should be_nil
  end

end
