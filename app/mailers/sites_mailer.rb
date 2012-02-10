class SitesMailer < ActionMailer::Base
  include Resque::Mailer
  include ActionView::Helpers::DateHelper

  helper :sites

  default :from => Settings.email.sender
  default_url_options[:host] = Settings.domain

  def notify_error(site_id)
    @site = Site.find(site_id)
    @subject = "Error detected for #{@site.url}"
    mail(:to => Settings.email.receiver, :subject => @subject)
  end

  def notify_resolved(site_id)
    @site = Site.find(site_id)
    @downtime = time_ago_in_words(@site.failed_at)
    @subject = "Error resolved for #{@site.url}"
    mail(:to => Settings.email.receiver, :subject => @subject)
  end  
end
