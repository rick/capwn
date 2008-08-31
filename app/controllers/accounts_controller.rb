class AccountsController < ApplicationController
  before_filter :admin_required, :except => 'index'

  resources_controller_for :accounts

  # Used to redirect on failed :admin_required
  def admin_required_params
    { 
      :return_url => accounts_path,
      :message    => "We're sorry, only admins have access to modify or create accounts" 
    }
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

  def find_resources
    resource_service.find :all,
      :conditions => ['active = ?', true],
      :order => 'name'
  end
end
