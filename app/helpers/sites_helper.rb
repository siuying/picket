module SitesHelper
  include ActionView::Helpers::DateHelper 

  def icon_for_site(site)
    case site.state
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
      "#{site_name} will be watched soon"
    when "ok"
      "#{site_name} is running"
    when "failed"
      time_change = time_ago_in_words(site.failed_at)
      "#{site_name} is down since #{time_change} ago"
    else
      raise "unexpected state: #{site.state}"
    end
  end
  
  def validation_description(site)
    if site.content_validate_type
      "Contains \"#{site.content_validate_text}\""
    else
      "Doesn't contains \"#{site.content_validate_text}\""
    end
  end
  
end
