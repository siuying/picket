require 'site_fetcher'

class AllSitesFetcher
  @queue = :fetch
  def self.perform
    Site.only(:id).all.each do |site|
      Resque.enqueue(SiteFetcher, site.id.to_s)
    end
  end
end