class AdminController < ApplicationController
  layout 'admin'

  before_action :authenticate_user!
  before_action :ensure_admin!
  after_action :verify_authorized, except: :index, unless: :devise_controller?

  private

  def ensure_admin!
    redirect_to root_path, alert: "Access denied." unless current_user.admin? || current_user.operator?
  end
end
