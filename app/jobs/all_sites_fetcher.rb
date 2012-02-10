require 'site_fetcher'

class AllSitesFetcher
  @queue = :fetch
  
  # Enqueue a task to fetch all sites
  def self.perform
    Site.all.only(:id).each do |site|
      Resque.enqueue(SiteFetcher, site.id.to_s)
    end
  end
end