class SiteWatcher
  include SitesHelper
  
	def initialize(site)
    @site = site
  end
  
  def watch
    response = get_url(@site.url)

    if response.success?
      if content_valid?(response.body)
        @site.ok!
      else
        @site.failed!
        @site.message = "Validation fail: #{validation_description(@site)}"
      end
    elsif response.timed_out?
      @site.failed!
      @site.message = "Could not get a response from the server before timing out (10 seconds)."
    elsif response.code == 0
      @site.failed!
      @site.message = "Could not get an http response, something's wrong."    
    else
      @site.failed!
      @site.message = "Server returned: #{response.code.to_s} #{response.status_message}"
    end

    @site.state
  end
  
  private
  def content_valid?(content)
    return true if @site.content_validate_text.empty?
    return true if @site.content_validate_type.nil?
    return true if @site.content_validate_type && content.include?(@site.content_validate_text)
    return true if !@site.content_validate_type && !content.include?(@site.content_validate_text)
    return false
  end

  def get_url(url)
    request = Typhoeus::Request.new(url, :method => :get, :timeout => 10000, :follow_location => true)
    hydra = Typhoeus::Hydra.hydra
    hydra.queue(request)
    hydra.run
    request.response    
  end
end