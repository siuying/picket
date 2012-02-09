module SitesHelper
  def icons_for_site(site)
    case site.status
    when Site::STATUS_OK
      image_tag("icons/accept.png")
    when Site::STATUS_FAILED
      image_tag("icons/exclamation.png")
    end
  end
end
