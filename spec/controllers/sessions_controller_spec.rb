require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do

  # set up one valid user for testing purposes
  before :all do
    Login.delete_all
    Login.create!(
      :email                 => 'ogc@ogconsultin.gs',
      :salt                  => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd',
      :password              => 'test',
      :password_confirmation => 'test',
      :created_at            => 5.days.ago,
    )
  end
  
  before :each do
    @valid_user = Login.find_by_email('ogc@ogconsultin.gs')
  end
  
  it 'login form actions should use a custom layout' do
    get :new
    response.layout.should == 'layouts/login'
  end
  
  describe 'on successful login' do
    it 'should place login information in the session' do
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'test' }
      session[:login_id].should_not be_nil      
    end
    
    it 'should redirect to original url if one is available' do
      session[:return_to] = '/foo/bar'
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'test' }
      response.should redirect_to('/foo/bar')
    end
    
    it 'should redirect to previous location is no original url is available' do
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'test' }
      response.should redirect_to('/')
    end
    
    it 'should set remember me information if remember me is specified' do
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'test', :remember_me => "1" }
      response.cookies["auth_token"].should_not be_nil
    end

    it 'it should not set remember me information if remember me is not specified' do
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'test', :remember_me => "0" }
      response.cookies["auth_token"].should be_nil
    end
  end

  describe 'on unsuccessful login' do
    it 'should leave no login information in the session' do
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'bad password' }
      session[:login_id].should be_nil      
    end
    
    it 'should stay on the login page' do
      post :create, { :email => 'ogc@ogconsultin.gs', :password => 'bad password' }
      response.should be_success
    end
  end
  
  describe "when logging out" do
    it 'should delete login information from the session' do
      login_as @valid_user
      delete :destroy
      session[:login_id].should be_nil
      response.should be_redirect
    end

    it 'should redirect' do
      login_as @valid_user
      delete :destroy
      response.should be_redirect
    end
    
    it 'should clear remember me information' do
      login_as @valid_user
      delete :destroy
      response.cookies["auth_token"].should == []
    end
  end
  
  it 'should allow logging in via credentials in a cookie' do
    @valid_user.remember_me
    request.cookies["auth_token"] = cookie_for(@valid_user)
    get :new
    controller.send(:logged_in?).should be_true
  end
  
  it 'should not allow logging in with expired remember me credentials' do
    @valid_user.remember_me
    @valid_user.update_attribute :remember_token_expires_at, 5.minutes.ago
    request.cookies["auth_token"] = cookie_for(@valid_user)
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  it 'should not allow logging in with bad cookie credentials' do
    @valid_user.remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should_not be_true
  end
  
  # NOTE: this may not be the best way to test this, but the "best" way
  # probably involves making real requests and inspecting the logs
  it 'should filter parameters' do
    controller.should respond_to(:filter_parameters)
  end
  
  it 'should obscure password information in logs' do
    params = {'password' => 'blah', 'password_confirmation' => 'blah'}
    result = controller.filter_parameters(params)
    result['password'].should == '[FILTERED]'
    result['password_confirmation'].should == '[FILTERED]'
  end
  
  it 'should not obscure non-password information in logs' do
    params = {'email' => 'blah'}
    result = controller.filter_parameters(params)
    result['email'].should == params['email']
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(login)
    auth_token login.remember_token
  end
end
