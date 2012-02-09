# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'    

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'      

    schedule_path = File.expand_path('../../../config/schedule.yml', __FILE__)
    Resque.schedule = YAML.load_file(schedule_path)

    require 'all_sites_fetcher'
  end
end