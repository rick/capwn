require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do
  def redirects_to_index 
    true
  end

  it_should_behave_like 'a RESTful controller requiring login'

  it 'should allow non-admins to view list of accounts' do
    account = stub(:account)
    accounts = [account]
    Account.stubs(:find).returns(accounts)
    login_as User.generate(:isAdmin => false)
    get :index

    response.should render_template('index')
  end
end

describe AccountsController do

  before :each do
    account = stub(:account)
    accounts = [account]
    Account.stubs(:find).returns(accounts)
    login_as User.generate(:isAdmin => false)
  end

  it 'should not allow non-admins to access new account functionality' do
    get :show, { :id => '1' }
    response.should redirect_to(accounts_url)
  end
  it 'should set an error message when a non-admin attempts to access new account functionality' do
    get :show, { :id => '1' }
    flash[:error].should include("We're sorry, only admins have access to modify or create accounts")
  end

  it 'should not allow non-admins to create an account' do
    post :create
    response.should redirect_to(accounts_url)
  end 
  it 'should set an error message when a non-admin attempts to create a new account' do
    post :create
    flash[:error].should include("We're sorry, only admins have access to modify or create accounts")
  end

  it 'should not allow non-admins to access edit account functionality' do
    get :edit, { :id => '1' }
    response.should redirect_to(accounts_url)
  end
  it 'should set an error message when a non-admin attempts to  acess edit account functionality' do
    get :edit, { :id => '1' }
    flash[:error].should include("We're sorry, only admins have access to modify or create accounts")
  end

  it 'should not allow non-admins to update an account' do
    put :update, { :id => '1' }
    response.should redirect_to(accounts_url)
  end 
  it 'should set an error message when a non-admin attempts to update an account' do
    put :update, { :id => '1' }
    flash[:error].should include("We're sorry, only admins have access to modify or create accounts")
  end

  it 'should not allow non-admins to destroy an account' do
    delete :destroy, { :id => '1' }
    response.should redirect_to(accounts_url)
  end 
  it 'should set an error message when a non-admin attempts to delete an account' do
    delete :destroy, { :id => '1' }
    flash[:error].should include("We're sorry, only admins have access to modify or create accounts")
  end
end

