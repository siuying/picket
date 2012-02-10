module SitesHelper
  include ActionView::Helpers::DateHelper 

  def icon_for_site(site)
    case site.status
    when "unknown"
      image_tag("icons/help.png")
    when "ok"
      image_tag("icons/accept.png")
    when "failed"
      image_tag("icons/exclamation.png")
    else
      raise "unexpected state: #{site.state}"
    end
  end

  def message_for_site(site)
    site_name = site.url.gsub(%r{^http://}, "")

    case site.state
    when "unknown"
      "#{site_name} will be watched within 5 minutes"
    when "ok"
      "#{site_name} is running"
    when "failed"
      time_change = time_ago_in_words(site.failed_at)
      "#{site_name} is down since #{time_change} ago"
    else
      raise "unexpected state: #{site.state}"
    end

  end
end
