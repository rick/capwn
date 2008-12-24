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
    self.resources = resource_service.active
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

  def inactive
    self.resources = resource_service.inactive
  end

  protected

end
