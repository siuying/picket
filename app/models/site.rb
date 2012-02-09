class Site
  include Mongoid::Document
  
  STATUS_OK = "ok"
  STATUS_FAILED = "failed"
  STATUS = [STATUS_OK, STATUS_FAILED]

  field :url, :type => String
  field :status, :type => String, :default => "ok"
  field :message, :type => String
  field :last_error_at, :type => DateTime

end
