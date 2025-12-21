class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :authenticate_user! # ensures users are logged in for most pages
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def after_sign_in_path_for(resource)
    if resource.admin? || resource.operator?
      admin_dashboard_path 
    else
      root_path
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :address, :phone_number, :city, :state])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :address, :phone_number, :city, :state])
  end

  def user_not_authorized
    # flash[:alert] = "You are not authorized to perform this action."
    redirect_to (request.referrer || ((current_user.admin? || current_user.operator?) ? admin_dashboard_path : root_path)), alert: "You are not authorized to perform this action."
  end
end
