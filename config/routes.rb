require 'resque/server'

Picket::Application.routes.draw do
  devise_for :users, :skip => :registrations

  resources :sites
  root :to => 'sites#index'
end
