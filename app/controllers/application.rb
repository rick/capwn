# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '2bb069e7ebabd91be82efa1e0900438b'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password

  before_filter :login_required

  def admin_required
    unless @current_user.isAdmin
      if defined? admin_required_params
        flash[:error] = admin_required_params[:message]
        redirect_to admin_required_params[:return_url]
      else
        flash[:error] = "Only admins can access this functionality"
        redirect_to root_path
      end
    end
  end
end
