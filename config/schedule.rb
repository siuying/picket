require 'rufus-scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.every '1m', :first => '5s' do
  Resque.enqueue(AllSitesFetcher)
end

scheduler.join