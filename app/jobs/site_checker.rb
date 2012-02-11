class SiteChecker
  @queue = :fetch

  # Check status of a site, if the status changed from anything to FAILED, or changed 
  # from FAILED to OK, send an email notification.
  #
  # site_id - id for the site to be fetched
  def self.perform(site_id, mailer=SitesMailer)
    site       = Site.find(site_id)
    was_failed = site.failed?
    now_state  = SiteWatcher.new(site).watch

    if was_failed && now_state == "ok"
      mailer.notify_resolved(site.id).deliver
    elsif !was_failed && now_state == "failed"
      mailer.notify_error(site.id).deliver
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