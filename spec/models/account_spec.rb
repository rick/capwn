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

    it 'can have an isactive flag' do
      @account.should respond_to(:isactive)
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

  describe 'finders' do
    before :each do
      Account.generate(:name => 'account 01')
      Account.generate(:name => 'account 03')
      Account.generate(:name => 'account 02')
      Account.generate(:name => 'account 05')
      Account.generate(:name => 'account 04')
      Account.generate(:name => 'inactive account 02', :isactive => false)
      Account.generate(:name => 'inactive account 03', :isactive => false)
      Account.generate(:name => 'inactive account 01', :isactive => false)
    end
    
    it 'should find active accounts' do
      Account.active.count.should == 5
    end
    
    it 'should find inactive accounts' do
      Account.inactive.count.should == 3
    end

    it 'should order active accounts by name' do
      accounts = Account.active
      for i in (0...accounts.count - 1)
        puts i
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should order active accounts by name' do
      accounts = Account.inactive
      for i in (0...accounts.count - 1)
        puts i
        accounts[i].name.should < accounts[i+1].name
      end
    end
  end
end
  
