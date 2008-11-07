class JournalsController < ApplicationController
  before_filter :admin_required

  def show
    @account = Account.find(params[:id]) 
  end
end
