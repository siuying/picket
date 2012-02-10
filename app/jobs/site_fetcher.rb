class SiteFetcher
  @queue = :fetch
  extend ActionView::Helpers::DateHelper
  
  def self.perform(site_id)
    site = Site.find(site_id)
    response = get_url(site.url)
    last_status = site.status
    last_change = site.status_changed_at
    
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
      site.message = "Server returned: #{response.code.to_s} #{response.status_message}"
    end

    if site.status_changed?
      if last_status == Site::STATUS_FAILED && site.status == Site::STATUS_OK
        SitesMailer.notify_resolved(site.id, time_ago_in_words(last_change)).deliver
      elsif last_status == Site::STATUS_OK && site.status == Site::STATUS_FAILED
        SitesMailer.notify_error(site.id).deliver
      end
      site.status_changed_at = Time.now
    end

    site.save!
  end
  
  def self.get_url(url)
    request = Typhoeus::Request.new(url, :method => :get, :timeout => 10000, :follow_location => true)
    hydra = Typhoeus::Hydra.hydra
    hydra.queue(request)
    hydra.run
    request.response    
  end
end