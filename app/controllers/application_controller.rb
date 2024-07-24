class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # User Role Authentication
  def authenticate_cashier
    redirect_to root_path unless current_user.role >= 1
  end

  def authenticate_manager
    redirect_to root_path unless current_user.role >= 2
  end

  def authenticate_supervisor
    redirect_to root_path unless current_user.role >= 3
  end

  def authenticate_owner
    redirect_to root_path unless current_user.role == 4
  end
end
