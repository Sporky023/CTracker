class ApplicationController < ActionController::Base
  protect_from_forgery

  def redirect_to_home_unless_authenticated
    if current_user.nil?
      redirect_to root_url
    end
  end
end
