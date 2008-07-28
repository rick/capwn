require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transaction do
  describe 'object' do
    before :each do
      @transaction = Transaction.new
    end
    
    it 'can have a user' do
      @transaction.should respond_to(:user)
    end
    
    it 'can have entries' do
      @transaction.should respond_to(:entries)
    end
    
    it 'can have a memo' do
      @transaction.should respond_to(:memo)
    end
    
    it 'can have a payment date' do
      @transaction.should respond_to(:paid_at)
    end
  end
  
  describe 'validations' do
    before :each do
      @user = User.generate!
      @transaction = Transaction.generate(:user => @user)
    end
    
    it 'must have a user to be valid' do
      @transaction.user = nil
      @transaction.should_not be_valid
      @transaction.should have(1).errors_on(:user)
    end
    
    it 'must have a payment date to be valid' do
      @transaction.paid_at = nil
      @transaction.should_not be_valid
      @transaction.should have(1).errors_on(:paid_at)      
    end
  end
end
  
