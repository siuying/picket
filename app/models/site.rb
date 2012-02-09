class Site
  include Mongoid::Document
  include Mongoid::Timestamps
    
  STATUS_OK = "ok"
  STATUS_FAILED = "failed"
  STATUS = [STATUS_OK, STATUS_FAILED]

  field :url, :type => String
  field :status, :type => String, :default => "ok"
  field :message, :type => String
  field :status_change_at, :type => DateTime

end
