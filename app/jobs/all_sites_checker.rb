require 'site_checker'

class AllSitesChecker
  @queue = :fetch
  
  # Enqueue a task to fetch all sites
  def self.perform
    Site.all.only(:id).each do |site|
      Resque.enqueue(SiteChecker, site.id.to_s)
    end
  end
end