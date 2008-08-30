require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  describe 'object' do
    before :each do
      @account = Account.new
    end
    
    it 'can have entries' do
      @account.should respond_to(:entries)
    end
    
    it 'can have a name' do
      @account.should respond_to(:name)
    end

    it 'can have an initial balance' do
      @account.should respond_to(:initialBalance)
    end
    
    it 'can have a formatted initial balance' do
      @account.should respond_to(:formatted_initial_balance)
    end
  end
  
  describe 'validations' do
    before :each do
      @account = Account.generate
    end
    
    it 'must have a name to be valid' do
      @account.name = nil
      @account.should_not be_valid
      @account.should have(1).errors_on(:name)
    end
    
    it 'must have an unique name to be valid' do
      account = Account.generate!
      dup = Account.generate(:name => account.name)
      dup.should_not be_valid
      dup.should have(1).errors_on(:name)
    end

    it 'must have an initial balance to be valid' do
      @account.initialBalance = nil
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:initialBalance)
      @account.errors.on(:initialBalance).should include("can't be blank")
    end

    it 'must have a numeric initial balance to be valid' do
      @account.initialBalance = 'invalid balance'
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:initialBalance)
      @account.errors.on(:initialBalance).should include("is not a number")
    end

    it 'must have an initial balance at least 0 to be valid' do
      @account.initialBalance = -1.0
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:initialBalance)
      @account.errors.on(:initialBalance).should include("must be greater than or equal to 0")
    end
  end
end
  
