require File.dirname(__FILE__) + '/../spec_helper'

describe SessionsController do

  # set up one valid user for testing purposes
  before :all do
    User.delete_all
    @user = User.generate!
  end

  describe 'on successful login' do
    it 'should place login information in the session' do
      post :create, { :login => @user.login, :password => @user.password }
      session[:user_id].should_not be_nil      
    end

    it 'should redirect to return_to url if available' do
      session[:return_to] = '/foo/bar'
      post :create, { :login => @user.login, :password => @user.password }
      response.should redirect_to('/foo/bar')
    end

    it 'should redirect to root url if no return_to url is available ' do
      post :create, { :login => @user.login, :password => @user.password }
      response.should redirect_to('/')
    end
    
    it 'should set remember me information if remember me is specified' do
      post :create, { :login => @user.login, 
        :password => @user.password,
        :remember_me => "1"}
      response.cookies["auth_token"].should_not be_blank
    end

    it 'it should not set remember me information if remember me is not specified' do
      post :create, { :login => @user.login, 
        :password => @user.password,
        :remember_me => "0"}
      response.cookies["auth_token"].should be_blank
    end
  end

  describe 'on unsuccessful login' do
    it 'should leave no login information in the session' do
      post :create, { :login => @user.login, :password => 'wrong_password' }
      session[:login_id].should be_nil      
    end

    it 'should stay on the login page' do
      session[:return_to] = '/foo/bar'
      post :create, { :login => @user.login, :password => 'wrong_password' }
      response.should_not redirect_to('/foo/bar')
    end
  end

  describe "when logging out" do
    before :each do
      post :create, { :login => @user.login, 
        :password => @user.password,
        :remember_me => "1"}
    end

    it 'should delete login information from the session' do
      delete :destroy
      session[:login_id].should be_nil
      response.should be_redirect
    end

    it 'should redirect' do
      delete :destroy
      response.should be_redirect
    end
    
    it 'should clear remember me information' do
      response.cookies["auth_token"].should_not be_blank
      delete :destroy
      response.cookies["auth_token"].should be_blank
    end
  end

  describe 'credentials' do
    it 'should allow logging in via a cookie' do
      @user.remember_me
      request.cookies["auth_token"] = cookie_for(@user)
      get :new
      controller.send(:logged_in?).should be_true
    end

    it 'should not allow logging in when expired' do
      @user.remember_me
      @user.update_attribute :remember_token_expires_at, 5.minutes.ago
      request.cookies["auth_token"] = cookie_for(@user)
      get :new
      controller.send(:logged_in?).should_not be_true
    end

    it 'should not allow logging in via bad cookie' do
      @user.remember_me
      request.cookies["auth_token"] = auth_token('invalid_auth_token')
      get :new
      controller.send(:logged_in?).should_not be_true
    end
  end

  describe 'parameter filter' do
    it 'should be enabled' do
      controller.should respond_to(:filter_parameters)
    end

    it 'should obscure password information in logs' do
      params = {'password' => 'blah', 'password_confirmation' => 'blah'}
      result = controller.send(:filter_parameters, params)
      result['password'].should == '[FILTERED]'
      result['password_confirmation'].should == '[FILTERED]'
    end
  
    it 'should not obscure non-password information in logs' do
      params = {'email' => 'blah'}
      result = controller.send(:filter_parameters, params)
      result['email'].should == params['email']
    end
  end

  private
  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end
    
  def cookie_for(login)
    auth_token login.remember_token
  end
end
