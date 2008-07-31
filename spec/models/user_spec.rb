require File.dirname(__FILE__) + '/../spec_helper'

describe User do

  describe 'attributes' do
    before :each do
      #TODO: Use Object Daddy's generate
      @user = User.generate
    end

    it 'should have a login' do
      @user.should respond_to(:login)
    end

    it 'should have an e-mail address' do
      @user.should respond_to(:email)
    end

    it 'should have a name' do
      @user.should respond_to(:name)
    end

    it 'should have a password' do
      @user.should respond_to(:password)
    end

    it 'should have a password_confirmation' do
      @user.should respond_to(:password_confirmation)
    end
  end  

  describe 'validity checks' do
    describe 'login' do
      it 'should not be valid when blank' do
        user = User.generate(:login => nil)
        user.should_not be_valid
        user.errors.on(:login).should(
          include("can't be blank"))
      end

      it 'should not be valid with less than 3 characters' do
        user = User.generate(:login => 'lo')
        user.should_not be_valid
        user.errors.on(:login).should(
          include("is too short (minimum is 3 characters)"))
      end

      it 'should not be valid with more than 40 characters' do
        chars = ("a".."z").to_a
        login = ""
        101.times do 
          login << chars[rand(chars.size-1)] 
        end
        user = User.generate(:login => login)
        user.should_not be_valid
        user.errors.on(:login).should(
          include("is too long (maximum is 40 characters)"))
      end

      it 'should be considered unique when case is different' do
        user = User.generate(:login => 'CASESENSITIVELOGIN') 
        user.should be_valid

        user_case_sensitive = User.generate(:login => 'casesenstivielogin')
        user.should be_valid
      end

      it 'should validate format to only include letters, number, and . - _ @' do
        user = User.generate(:login => 'validlogin1.-_@') 
        user.should be_valid

        user.login = 'invalid,' 
        user.should_not be_valid
        user.errors.on(:login).should(
          include("use only letters, numbers, and .-_@ please."))
      end
    end

    describe 'name' do

      it 'should validate format to only include printing characters (no newlines or tabs) and no <, >, or &' do
        user = User.generate 
        user.should be_valid

        user.name = 'invalid\n' 
        user.should_not be_valid
        user.errors.on(:name).should(
          include("avoid non-printing characters and \\&gt;&lt;&amp;/ please."))

          user.name = 'invalid\t' 
          user.should_not be_valid
          user.errors.on(:name).should(
            include("avoid non-printing characters and \\&gt;&lt;&amp;/ please."))

            user.name = 'invalid<' 
            user.should_not be_valid
            user.errors.on(:name).should(
              include("avoid non-printing characters and \\&gt;&lt;&amp;/ please."))

              user.name = 'invalid>' 
              user.should_not be_valid
              user.errors.on(:name).should(
                include("avoid non-printing characters and \\&gt;&lt;&amp;/ please."))

                user.name = 'invalid&' 
                user.should_not be_valid
                user.errors.on(:name).should(
                  include("avoid non-printing characters and \\&gt;&lt;&amp;/ please."))
      end

      it 'should not be valid with more than 100 characters' do
        chars = ("a".."z").to_a
        name = ""
        101.times do 
          name << chars[rand(chars.size-1)] 
        end
        user = User.generate(:name => name)
        user.should_not be_valid
        user.errors.on(:name).should(
          include("is too long (maximum is 100 characters)"))
      end
    end

    describe 'email' do
      it 'should not be valid when blank' do
        user = User.generate(:email => nil)
        user.should_not be_valid
        user.errors.on(:email).should(
          include("can't be blank"))
      end

      it 'should not be valid with less than 6 characters' do
        user = User.generate(:email => 'email')
        user.should_not be_valid
        user.errors.on(:email).should(
          include("is too short (minimum is 6 characters)"))
      end

      it 'should not be valid without a email with more than 100 characters' do
        chars = ("a".."z").to_a
        email = ""
        101.times do 
          email << chars[rand(chars.size-1)] 
        end
        user = User.generate(:email => email)
        user.should_not be_valid
        user.errors.on(:email).should(
          include("is too long (maximum is 100 characters)"))
      end

      it 'should not have a unique email that is case sensitive' do
        user = User.generate(:email => 'CASESENSITIVE@domain.com') 
        user.should be_valid

        user_case_sensitive = User.generate(:email => 'casesensitive@domain.com')
        user.should be_valid
      end

      it 'should validate format to look like an email' do
        user = User.generate
        user.should be_valid

        user.email = 'invalid' 
        user.should_not be_valid
        user.errors.on(:email).should(
          include("should look like an email address."))

        user.email = 'invalid@domain' 
        user.should_not be_valid
        user.errors.on(:email).should(
          include("should look like an email address."))
      end
    end
  end

  describe 'authentication' do
    before :each do
      @user = User.generate!
    end
    it 'should use login and password' do
      User.authenticate(@user.login, @user.password).should == @user
    end
    it 'should fail when the login does not match' do
      User.authenticate('somerandomlogin', @user.password).should be_nil
    end
    it 'should fail when the password does not match' do
      User.authenticate(@user.login, 'somerandompassword').should be_nil
    end
    it 'should use updated password when changed' do
      @user.update_attributes(:password => 'newpassword1', :password_confirmation => 'newpassword1')
      User.authenticate(@user.login, @user.password).should == @user
    end

    it 'should not update password when only changing login' do
      @user.update_attributes(:login => 'newlogin')
      User.authenticate(@user.login, @user.password).should == @user
    end
  end
end

