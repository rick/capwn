class AccountsController < ApplicationController
  resources_controller_for :accounts

  def find_resources
    resource_service.find :all, :order => 'name'
  end
end
