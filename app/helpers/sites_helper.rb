module SitesHelper
  include ActionView::Helpers::DateHelper 

  def icon_for_site(site)
    case site.status
    when Site::STATUS_OK
      image_tag("icons/accept.png")
    when Site::STATUS_FAILED
      image_tag("icons/exclamation.png")
    end
  end

  def message_for_site(site)
    case site.status
    when Site::STATUS_OK
      site_name = site.url.gsub(%r{^http://}, "")
      "#{site_name} is running"
    when Site::STATUS_FAILED
      site_name = site.url.gsub(%r{^http://}, "")
      time_change = time_ago_in_words(site.status_change_at)
      "#{site_name} is down since #{time_change} ago"
    end

  end
end
