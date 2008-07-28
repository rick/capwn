require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Entry do
  describe 'object' do
    before :each do
      @entry = Entry.new
    end
    
    it 'can have an account' do
      @entry.should respond_to(:account)
    end
    
    it 'can have a transaction' do
      @entry.should respond_to(:transaction)
    end
    
    it 'can have an amount' do
      @entry.should respond_to(:amount)
    end
  end
  
  describe 'validations' do
    before :each do
      @account = Account.generate!
      @entry = Entry.generate(:account => @account)
    end
    
    it 'must have an account to be valid' do
      @entry.account = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:account)
    end
    
    it 'must have an amount to be valid' do
      @entry.amount = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:amount)
    end
    
    it 'must have a transaction to be valid' do
      @entry.transaction = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:transaction)
    end
  end
end
  
