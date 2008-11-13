require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Memo do
  describe 'object' do
    before :each do
      @memo = Memo.new
    end
    
    it 'can have a user' do
      @memo.should respond_to(:user)
    end
    
    it 'can have entries' do
      @memo.should respond_to(:entries)
    end
    
    it 'can have a text' do
      @memo.should respond_to(:text)
    end
    
    it 'can have a payment date' do
      @memo.should respond_to(:paid_at)
    end
  end
  
  describe 'validations' do
    before :each do
      @user = User.generate!
      @memo = Memo.generate(:user => @user)
    end
    
    it 'must have a user to be valid' do
      @memo.user = nil
      @memo.should_not be_valid
      @memo.should have(1).errors_on(:user)
    end
    
    it 'must have a payment date to be valid' do
      @memo.paid_at = nil
      @memo.should_not be_valid
      @memo.should have(1).errors_on(:paid_at)      
    end
  end
end
  
