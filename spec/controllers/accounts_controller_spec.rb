require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do
  def redirects_to_index 
    true
  end

  def finder
    {:method => :active}
  end

  it_should_behave_like 'a RESTful controller with a show action requiring login'
  it_should_behave_like 'a RESTful controller with a new action requiring login'
  it_should_behave_like 'a RESTful controller with a create action requiring login'
  it_should_behave_like 'a RESTful controller with an edit action requiring login'
  it_should_behave_like 'a RESTful controller with an update action requiring login'
  it_should_behave_like 'a RESTful controller with a destroy action requiring login'

  it 'should allow non-admins to view list of accounts' do
    account = stub(:account)
    accounts = [account]
    Account.stubs(:find).returns(accounts)
    login_as User.generate(:admin => false)
    get :index

    response.should render_template('index')
  end
end

describe AccountsController, "handling GET /plural (index)" do

  it 'should assign asset accounts' do
    pending
    login_as User.generate
    Account.expects(:assets)
    get :index
  end

  it 'should return liability accounts' do
    pending
    login_as User.generate
    Account.expects(:liabilities)
    get :index
  end

  it 'should return equity accounts' do
    pending
    login_as User.generate
    Account.expects(:equities)
    get :index
  end

  it 'should return revenue accounts' do
    pending
    login_as User.generate
    Account.expects(:revenues)
    get :index
  end

  it 'should return expense accounts' do
    pending
    login_as User.generate
    Account.expects(:expenses)
    get :index
  end
end

describe AccountsController, "handling GET /plural (inactive)" do
  it 'should assign inactive accounts when params[:active] == false' do
    login_as User.generate

    Account.expects(:inactive).returns [stub(:account, :active => false)]

    get :inactive
  end
end

describe AccountsController, 'administration' do

  before :each do
    account = stub(:account)
    accounts = [account]
    Account.stubs(:active).returns(accounts)
    login_as User.generate(:admin => false)
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

