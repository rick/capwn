require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do

  describe 'when creating a new user' do
    it 'should display new user form' do
      get :new
      response.should render_template(:new)
    end
  end

  describe 'when created successfully' do
    before :each do
    end
    it 'should save the new user' do
      lambda do
        create_user
      end.should change(User, :count).by(1)                                         end
    it "should set a successfully saved flash notice" do
      User.any_instance.stubs(:save).returns(true)
      create_user
      flash[:notice].should include('Thanks for signing up!')
    end 
    it 'should redirect to return_to url if available' do
      session[:return_to] = '/foo/bar'
      User.any_instance.stubs(:save).returns(true)
      create_user
      response.should redirect_to('/foo/bar')
    end
    it 'should redirect to root url if no return url is available' do
      User.any_instance.stubs(:save).returns(true)
      create_user
      response.should redirect_to('/')
    end
  end

  describe 'when unsuccessfully attempted to save the new user' do
    before :each do
      User.any_instance.stubs(:save).returns(false)
      create_user
    end
    it "should set an error message" do
      flash[:error].should include("We couldn't set up that account, sorry.")
    end
    it "should re-render new template" do
      response.should render_template(:new)
    end
  end

  private

  def create_user(options = {})
    user = User.spawn
    post :create, :user => { 
      :login => user.login,
      :email => user.email,
      :password => user.password,
      :password_confirmation => user.password_confirmation
    }.merge(options)
    return user
  end
end

