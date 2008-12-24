class AccountsController < ApplicationController
  before_filter :admin_required, :except => ['index', 'active', 'inactive']

  resources_controller_for :accounts

  # Used to redirect on failed :admin_required
  def admin_required_params
    { 
      :return_url => accounts_path,
      :message    => "We're sorry, only admins have access to modify or create accounts" 
    }
  end

  def index
    find_resources_and_set_links
  end

  def create
    self.resource = new_resource
    if resource.save
      redirect_to accounts_path
    else
      render :action => "new"
    end
  end
  def update
    self.resource = find_resource
    resource.attributes = params[resource_name]

    if resource.save
      redirect_to accounts_path
    else
      render :action => "edit"
    end
  end

  def active
    find_resources_and_set_links
    render :action => 'index'
  end

  def inactive
    find_resources_and_set_links
    render :action => 'index'
  end

  protected

  def find_resources
    if params[:action] == "inactive"
      resource_service.inactive
    else
      resource_service
    end
  end

  def url_for_active_accounts
    "<a href=\"#{url_for(:controller => 'accounts', :action => 'active')}\">View Active Accounts</a>"
  end

  def url_for_inactive_accounts
    "<a href=\"#{url_for(:controller => 'accounts', :action => 'inactive')}\">View Inactive Accounts</a>"
  end
  def find_resources_and_set_links
    self.resources = find_resources

    if params[:action] == "inactive"
      flash[:link] = url_for_active_accounts 
    else
      flash[:link] = url_for_inactive_accounts
    end
  end
end
