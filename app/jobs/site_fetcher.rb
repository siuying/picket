class SiteFetcher
  @queue = :fetch
  extend ActionView::Helpers::DateHelper
  
  # Fetch a site and log the result and update site according to the result.
  #
  # Side Effect: If the status changed from anything to FAILED, or changed 
  # from FAILED to OK, send an email notification.
  #
  # site_id - id for the site to be fetched
  def self.perform(site_id)
    site            = Site.find(site_id)
    response        = get_url(site.url)

    last_status_failed = site.failed?
    last_status_change = site.status_changed_at
    
    if response.success?
      site.status = Site::STATUS_OK
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
      if last_status_failed && site.ok?
        SitesMailer.notify_resolved(site.id, time_ago_in_words(last_status_change)).deliver
      elsif !last_status_failed && site.failed?
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