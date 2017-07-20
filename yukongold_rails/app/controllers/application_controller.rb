class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  layout :layout_by_resource

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    "/home"
  end

  # def after_sign_out_path_for(resource_or_scope)
  #   request.referrer
  # end

  protected
    def layout_by_resource
      if devise_controller? && resource_name == :user && action_name == "new"
        "splash"
      else
        "application"
      end
    end
end  

