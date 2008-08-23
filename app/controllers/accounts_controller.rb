class AccountsController < ApplicationController
  resources_controller_for :accounts

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
    resource_service.find :all, :order => 'name'
  end
end
