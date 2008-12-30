require File.dirname(__FILE__) + '/../spec_helper'

describe AccountsController do
  def redirects_to_index 
    true
  end

  def finder
    {:method => :active}
  end

  describe '' do # Shared behaviors
    it_should_behave_like 'a RESTful controller with a show action requiring login'
    it_should_behave_like 'a RESTful controller with a new action requiring login'
    it_should_behave_like 'a RESTful controller with a create action requiring login'
    it_should_behave_like 'a RESTful controller with an edit action requiring login'
    it_should_behave_like 'a RESTful controller with an update action requiring login'
    it_should_behave_like 'a RESTful controller with a destroy action requiring login'
  end

  it 'should allow non-admins to view list of accounts' do
    account = stub(:account)
    accounts = [account]
    Account.stubs(:find).returns(accounts)
    login_as User.generate(:admin => false)
    get :index

    response.should render_template('index')
  end

  it 'should allow non-admins to view list of inactive accounts' do
    account = stub(:account)
    accounts = [account]
    Account.stubs(:find).returns(accounts)
    login_as User.generate(:admin => false)
    get :inactive

    response.should render_template('inactive')
  end
end

describe AccountsController, "handling GET /plural (index)" do

  it 'should find active accounts' do
    login_as User.generate
    Account.expects(:active)
    get :index
  end

  it 'should assign accounts' do
    login_as User.generate
    get :index
    assigns[:accounts]
  end

  it 'should assign active accounts by element with headers' do
    login_as User.generate
    get :index
    accounts = assigns[:accounts]
    accounts.class.should eql(Array)
    for i in 0...accounts.length
      if i % 2 == 0
        accounts[i].class.should eql(String)
      else
        accounts[i].class.should eql(ActiveRecord::NamedScope::Scope)
      end
    end
  end

  it 'should render default index template' do
    login_as User.generate
    get :index
    response.should render_template('index')
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

describe AccountsController, 'handling GET /singular (journal)' do
  it 'should assign the selected account' do
    login_as User.generate
    account = stub(:account, :id => 666)
    Account.expects(:find).with("666").returns(account)
    get :journal, :id => "666"
    assigns[:account].should_not be_nil
  end
end

