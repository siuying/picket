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

    was_failed = site.failed?

    if response.success?
      site.ok!
    elsif response.timed_out?
      site.failed!
      site.message = "Could not get a response from the server before timing out (10 seconds)."
    elsif response.code == 0
      site.failed!
      site.message = "Could not get an http response, something's wrong."    
    else
      site.failed!
      site.message = "Server returned: #{response.code.to_s} #{response.status_message}"
    end

    if was_failed && site.ok?
      SitesMailer.notify_resolved(site.id).deliver
    elsif !was_failed && site.failed?
      SitesMailer.notify_error(site.id).deliver
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