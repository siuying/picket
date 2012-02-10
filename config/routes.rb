Picket::Application.routes.draw do
  get "/profile" => 'user#index'
  post "/profile" => 'user#update'

  devise_for :users, :skip => :registrations

  resources :sites
  root :to => 'sites#index'
  
  
  if Rails.env.development?
    require 'resque/server'
    mount Resque::Server.new, :at => "/resque"
  end
  
end
