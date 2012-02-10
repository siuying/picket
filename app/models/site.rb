require 'transitions'

class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveRecord::Transitions
  
  field :url, :type => String
  field :state, :type => String
  field :message, :type => String, :default => ""

  field :ok_at, :type => DateTime
  field :failed_at, :type => DateTime
  
  validates_presence_of :url
  validates_format_of :url, :with => %r{^http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$}

  state_machine do
    state :unknown
    state :ok
    state :failed
    
    event :ok, :timestamp => true do
      transitions :from => [:ok, :failed, :unknown], :to => :ok
    end

    event :failed, :timestamp => true do
      transitions :from => [:ok, :failed, :unknown], :to => :failed      
    end
    
    event :reset do
      transitions :from => [:ok, :failed], :to => :unknown
    end
  end

end
