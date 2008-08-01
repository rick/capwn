require File.dirname(__FILE__) + '/../spec_helper'

describe Login do
  # set up one valid user for testing purposes
  before :all do
    Login.delete_all
    # TODO:  replace with an object_daddy Login.generate! call
    Login.create!(
      :email                 => 'ogc@ogconsultin.gs',
      :salt                  => '7e3041ebc2fc05a40c60028e2c4901a81035d3cd',
      :password              => 'test',
      :password_confirmation => 'test',
      :created_at            => 5.days.ago,
    )
  end
  
  before :each do
    @valid_login = Login.find_by_email('ogc@ogconsultin.gs')
    @params = {
      :email                 => 'rick@ogconsultin.gs',
      :password              => 'test',
      :password_confirmation => 'test',   
    }
    @login = Login.new
  end

  describe 'attributes' do
    it 'has an e-mail addr' do
      @login.should respond_to(:email)
    end
    
    it 'should have a password' do
      @login.should respond_to(:password)
    end
  end  

  describe 'validity checks' do
    it 'should not be valid without an email' do
      login = Login.new(@params.merge(:email => nil))
      login.should_not be_valid
      login.should have_at_least(1).error_on(:email)
    end
  
    it 'should not be valid without a password' do
      login = Login.new(@params.merge(:password => nil))
      login.should_not be_valid
      login.should have_at_least(1).error_on(:password)
    end
  
    it 'should not be valid without a password confirmation' do
      login = Login.new(@params.merge(:password_confirmation => nil))
      login.should_not be_valid
      login.should have_at_least(1).error_on(:password_confirmation)
    end
  
    it 'should be valid with an email, password, and password confirmation' do
      login = Login.new(@params)
      login.should be_valid
    end
    
    it 'should require e-mail to be unique' do
      login = Login.new(@params.merge(:email => @valid_login.email))
      login.valid?
      login.should have(1).error_on(:email)
    end
  end
  
  describe 'password maintenance' do
    it 'should use updated password when authenticating' do
      @valid_login.update_attributes(:password => 'new password', :password_confirmation => 'new password')
      Login.authenticate('ogc@ogconsultin.gs', 'new password').should == @valid_login
    end

    it 'should not update password when only changing email' do
      @valid_login.update_attributes(:email => 'o@ogconsultin.gs')
      Login.authenticate('o@ogconsultin.gs', 'test').should == @valid_login
    end

    it 'should allow login when correct email and password are provided' do
      Login.authenticate('ogc@ogconsultin.gs', 'test').should == @valid_login
    end
    
    it 'should store a set password' do
      val = 'asdfghjkl'
      @login.password = val
      @login.password.should == val
    end
  end
 
  describe "remember me functionality" do
    it 'remember_me should set remember token' do
      @valid_login.remember_me
      @valid_login.remember_token.should_not be_nil
    end
  
    it 'remember_me should set remember token expiration' do
      @valid_login.remember_me
      @valid_login.remember_token_expires_at.should_not be_nil    
    end

    it 'forget_me should clear remember token' do
      @valid_login.remember_me
      @valid_login.forget_me
      @valid_login.remember_token.should be_nil
    end
  
    it 'forget_me should clear remember token expiration' do
      @valid_login.remember_me
      @valid_login.forget_me
      @valid_login.remember_token_expires_at.should be_nil    
    end

    it 'remember_me_for should set remember token expiration to specified duration' do
      before = 1.week.from_now.utc
      @valid_login.remember_me_for 1.week
      after = 1.week.from_now.utc
      @valid_login.remember_token_expires_at.between?(before, after).should be_true    
    end
  
    it 'remember_me_until should set remember token expiration to specified time' do
      time = 1.week.from_now.utc
      @valid_login.remember_me_until time
      @valid_login.remember_token_expires_at.should == time    
    end

    it 'remember_me should default expiration to two weeks from now' do
      before = 2.weeks.from_now.utc
      @valid_login.remember_me
      after = 2.weeks.from_now.utc
      @valid_login.remember_token_expires_at.between?(before, after).should be_true
    end
  end

  describe 'authentication checking' do
    before :each do
      @pass = 'asdfgzxcv'
      @login.password = @pass
    end
    
    it 'should require an argument' do
      lambda { @login.authenticated? }.should raise_error(ArgumentError)
    end
    
    it 'should accept an argument' do
      lambda { @login.authenticated?('arg') }.should_not raise_error(ArgumentError)
    end
    
    it 'should pass if the given password matches' do
      @login.authenticated?(@pass).should be(true)
    end
    
    it 'should fail if the given password does not match' do
      @login.authenticated?('badpass').should be(false)
    end
  end
  
  describe 'authenticating' do
    before :each do
      @login = Login.new
      Login.stubs(:find_by_email).returns(@login)
      @email = 'email'
      @pass  = 'pass'
    end
    
    it 'should require an email' do
      lambda { Login.authenticate }.should raise_error(ArgumentError)
    end
    
    it 'should require a password' do
      lambda { Login.authenticate(@email) }.should raise_error(ArgumentError)
    end
    
    it 'should accept an email and password' do
      lambda { Login.authenticate(@email, @pass) }.should_not raise_error(ArgumentError)
    end
    
    it 'should find the login for the given email' do
      Login.expects(:find_by_email).with(@email)
      Login.authenticate(@email, @pass)
    end
    
    it 'should return nil if there is no login for the given email' do
      Login.stubs(:find_by_email).returns(nil)
      Login.authenticate(@email, @pass).should be_nil
    end
    
    it 'should check the password on the returned login' do
      @login.expects(:authenticated?).with(@pass)
      Login.authenticate(@email, @pass)
    end
    
    describe 'when the password is accepted' do
      before :each do
        @login.stubs(:authenticated?).returns(true)
      end
      
      it 'should clear the failure count' do
        @login.expects(:update_attributes).with(:failure_count => 0)
        Login.authenticate(@email, @pass)
      end
      
      it 'should return the login' do
        Login.authenticate(@email, @pass).should == @login
      end
    end

    describe 'when the password is not accepted' do
      before :each do
        @login.stubs(:authenticated?).returns(false)
      end
      
      it 'should return nil' do
        Login.authenticate(@email, @pass).should be_nil
      end
    end
  end
end

