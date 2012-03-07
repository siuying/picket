require 'transitions'

class Site
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveRecord::Transitions
  
  attr_accessible :url
  
  field :url, :type => String
  field :state, :type => String, :default => "unknown"
  field :message, :type => String, :default => ""

  field :content_validate_type, :type => Boolean, :default => nil
  field :content_validate_text, :type => String, :default => ""

  field :ok_at, :type => DateTime
  field :failed_at, :type => DateTime

  belongs_to :user

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
      transitions :from => [:ok, :failed, :unknown], :to => :unknown
    end
  end
end
