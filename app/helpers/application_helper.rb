module ApplicationHelper
  def link_to_authentication
    if user_signed_in?
      link_to('Logout', destroy_user_session_path, :method => :delete)
    else
      link_to('Login', new_user_session_path)
    end
  end
end
