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
  field :status_change_at, :type => DateTime
  
  validates_presence_of :url
  validates_format_of :url, :with => %r{^http\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$}
  
  before_save :update_status
  
  protected
  def update_status
    if url_changed?
      self.status           = STATUS_UNKNOWN
      self.message          = ""
      self.status_change_at = Time.now
    end
  end
end
