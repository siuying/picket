class SiteFetcher
  @queue = :fetch
  
  def self.perform(site_id)
    site = Site.find(site_id)
    request = Typhoeus::Request.new(site.url, :method => :get, :timeout => 10000, :follow_location => true)

    hydra = Typhoeus::Hydra.hydra
    hydra.queue(request)
    hydra.run

    response = request.response
    last_status = site.status

    if response.success?
      site.status = Site::STATUS_OK
      site.message = "OK"
    elsif response.timed_out?
      site.status = Site::STATUS_FAILED
      site.message = "Could not get a response from the server before timing out (10 seconds)."
    elsif response.code == 0
      site.status = Site::STATUS_FAILED
      site.message = "Could not get an http response, something's wrong."    
    else
      site.status = Site::STATUS_FAILED
      site.message = response.code.to_s
    end
    site.status_change_at = Time.now if last_status != site.status
    
    site.save!
  end
end