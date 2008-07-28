require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe 'object' do
    before :each do
      @user = User.new
    end
    
    it 'can have transactions' do
      @user.should respond_to(:transactions)
    end
    
    it 'can have a name' do
      @user.should respond_to(:name)
    end
  end
  
  describe 'validations' do
    before :each do
      @user = User.generate
    end
    
    it 'must have a name to be valid' do
      @user.name = nil
      @user.should_not be_valid
      @user.should have(1).errors_on(:name)
    end
    
    it 'must have an unique name to be valid' do
      user = User.generate!
      dup = User.generate(:name => user.name)
      dup.should_not be_valid
      dup.should have(1).errors_on(:name)
    end
  end
end
  
