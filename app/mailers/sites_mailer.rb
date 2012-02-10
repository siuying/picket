class SitesMailer < ActionMailer::Base
  include Resque::Mailer

  layout 'notify'
  default :from => Settings.email_sender
  default :charset => "utf-8"
  default :content_type => "text/html" 
  default_url_options[:host] = Settings.domain
  helper :sites

  def notify_error(site_id)
    @site = Site.find(site_id)
    @subject = "Error detected for #{@site.url}"
    mail(:to => @recipient.email, :subject => @subject, :template_name => 'notify_error')
  end

  def notify_resolved(site_id, downtime)
    @site = Site.find(site_id)
    @downtime = downtime
    @subject = "Error resolved for #{@site.url}"
    mail(:to => @recipient.email, :subject => @subject, :template_name => 'notify_resolved')
  end  
end
