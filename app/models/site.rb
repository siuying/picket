class Site
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUS_UNKNOWN = "unknown"    
  STATUS_OK     = "ok"
  STATUS_FAILED = "failed"
  STATUS = [STATUS_UNKNOWN, STATUS_OK, STATUS_FAILED]

  field :url, :type => String

  field :status, :type => String, :default => STATUS_UNKNOWN
  field :message, :type => String, :default => ""
  field :status_changed_at, :type => DateTime, :default => -> { Time.now }
  
  validates_presence_of :url
  validates_format_of :url, :with => %r{^http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$}

  def ok?
    status == STATUS_OK
  end
  
  def failed?
    status == STATUS_FAILED
  end

  # Reset status and status change date
  def reset
    self.status           = STATUS_UNKNOWN
    self.status_changed_at = Time.now
  end
end
