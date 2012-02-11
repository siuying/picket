require 'rufus-scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.every Settings.interval do
  Resque.enqueue(AllSitesChecker)
end

scheduler.join