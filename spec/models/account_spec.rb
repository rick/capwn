require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  describe 'object' do
    before :each do
      @account = Account.new
    end
    
    it 'can have debit_entries' do
      @account.should respond_to(:debit_entries)
    end
    
    it 'can have credit_entries' do
      @account.should respond_to(:credit_entries)
    end

    it 'can have entries' do
      @account.should respond_to(:entries)
    end
    
    it 'can have memos' do
      @account.should respond_to(:memos)
    end
    
    it 'can have a name' do
      @account.should respond_to(:name)
    end

    it 'can have an initial balance' do
      @account.should respond_to(:initial_balance)
    end
    
    it 'can have an active flag' do
      @account.should respond_to(:active)
    end

    it 'should have an element' do
      @account.should respond_to(:element)
    end

    it 'should only provide Asset, Liability, Equity, Revenue, and Expense in the list of elements' do
      Account::ELEMENTS.should eql ['Asset', 'Liability', 'Equity', 'Revenue', 'Expense']
    end
  end
  
  # validations
  describe do
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
      @account.initial_balance = nil
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:initial_balance)
      @account.errors.on(:initial_balance).should include("can't be blank")
    end

    it 'must have a numeric initial balance to be valid' do
      @account.initial_balance = 'invalid balance'
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:initial_balance)
      @account.errors.on(:initial_balance).should include("is not a number")
    end

    it 'must have an initial balance at least 0 to be valid' do
      @account.initial_balance = -1.0
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:initial_balance)
      @account.errors.on(:initial_balance).should include("must be greater than or equal to 0")
    end

    it 'should have an element' do
      @account.element = nil
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:element)
      @account.errors.on(:element).should include("can't be blank")
    end

    it 'should be valid with element Asset' do
      @account.element = 'Asset'
      @account.should be_valid
    end

    it 'should be valid with element Liability' do
      @account.element = 'Liability'
      @account.should be_valid
    end

    it 'should be valid with element Equity' do
      @account.element = 'Equity'
      @account.should be_valid
    end

    it 'should be valid with element Revenue' do
      @account.element = 'Revenue'
      @account.should be_valid
    end

    it 'should be valid with element Expense' do
      @account.element = 'Expense'
      @account.should be_valid
    end

    it 'should not be valid an element not one of Asset, Liability, Equity, Revenue, or Expense' do
      @account.element = 'Invalid'
      @account.should_not be_valid
      @account.should have_at_least(1).errors_on(:element)
      @account.errors.on(:element).should include("must be Asset, Liability, Equity, Revenue, or Expense")
    end
  end

  describe 'finders' do
    before :each do
      Account.generate(:name => 'active asset', :element => 'Asset', :active => true)
      Account.generate(:name => 'active asset 2', :element => 'Asset', :active => true)
      Account.generate(:name => 'inactive asset', :element => 'Asset', :active => false)
      Account.generate(:name => 'active liability', :element => 'Liability', :active => true)
      Account.generate(:name => 'active liability 2', :element => 'Liability', :active => true)
      Account.generate(:name => 'active liability 3', :element => 'Liability', :active => true)
      Account.generate(:name => 'inactive liability', :element => 'Liability', :active => false)
      Account.generate(:name => 'active equity', :element => 'Equity', :active => true)
      Account.generate(:name => 'active equity 2', :element => 'Equity', :active => true)
      Account.generate(:name => 'inactive equity', :element => 'Equity', :active => false)
      Account.generate(:name => 'active revenue', :element => 'Revenue', :active => true)
      Account.generate(:name => 'active revenue 2', :element => 'Revenue', :active => true)
      Account.generate(:name => 'active expense', :element => 'Expense', :active => true)
      Account.generate(:name => 'active expense 2', :element => 'Expense', :active => true)
    end
    
    it 'should find inactive accounts' do
      Account.inactive.count.should == 3
    end

    it 'should order active accounts by name' do
      accounts = Account.active
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should order inactive accounts by name' do
      accounts = Account.inactive
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should find asset accounts' do
      accounts = Account.assets.count.should == 2
    end

    it 'should order asset accounts by name' do
      accounts = Account.assets
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should find liability accounts' do
      accounts = Account.liabilities.count.should == 3
    end

    it 'should order liability accounts by name' do
      accounts = Account.liabilities
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should find equity accounts' do
      accounts = Account.equities.count.should == 2
    end

    it 'should order equity accounts by name' do
      accounts = Account.equities
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should find revenue accounts' do
      accounts = Account.revenues.count.should == 2
    end

    it 'should order revenue accounts by name' do
      accounts = Account.revenues
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should find expense accounts' do
      accounts = Account.expenses.count.should == 2
    end

    it 'should order expense accounts by name' do
      accounts = Account.expenses
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end
  end
end
  
