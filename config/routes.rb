require 'resque/server'

Picket::Application.routes.draw do
  resources :sites
  root :to => 'sites#index'

  if Rails.env == "development"
    mount Resque::Server.new, :at => "/resque" 
  end
end
