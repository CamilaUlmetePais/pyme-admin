class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Sets the minimum value for User's role to 1 ("Cashier") for access to the pertinent view. Otherwise, user is redirected to root path.
  def authenticate_cashier
    redirect_to root_path unless current_user.role >= 1
  end

  # Sets the minimum value for User's role to 2 ("Manager") for access to the pertinent view. Otherwise, user is redirected to root path.
  def authenticate_manager
    redirect_to root_path unless current_user.role >= 2
  end

  # Sets the minimum value for User's role to 3 ("Supervisor") for access to the pertinent view. Otherwise, user is redirected to root path.
  def authenticate_supervisor
    redirect_to root_path unless current_user.role >= 3
  end

  # Sets the minimum value for User's role to 4 ("Owner") for access to the pertinent view. Otherwise, user is redirected to root path. 
  def authenticate_owner
    redirect_to root_path unless current_user.role == 4
  end
end
