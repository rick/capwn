require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Entry do
  describe 'object' do
    before :each do
      @entry = Entry.new
    end
    
    it 'can have a debit account' do
      @entry.should respond_to(:debit_account)
    end
    
    it 'can have a credit account' do
      @entry.should respond_to(:credit_account)
    end
    
    it 'can have a memo' do
      @entry.should respond_to(:memo)
    end
    
    it 'can have an amount' do
      @entry.should respond_to(:amount)
    end
  end
  
  describe 'validations' do
    before :each do
      @entry = Entry.generate(:debit_account  => Account.generate!, 
                              :credit_account => Account.generate!)
    end
    
    it 'must have a debit account to be valid' do
      @entry.debit_account = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:debit_account)
    end
    
    it 'must have a credit account to be valid' do
      @entry.credit_account = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:credit_account)
    end
    
    it 'must have an amount to be valid' do
      @entry.amount = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:amount)
    end
    
    it 'must have a memo to be valid' do
      @entry.memo = nil
      @entry.should_not be_valid
      @entry.should have(1).errors_on(:memo)
    end
  end
end
  
