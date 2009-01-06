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
    
    it 'can have a balance' do
      @account.should respond_to(:balance)
    end
    
    it 'can have an active flag' do
      @account.should respond_to(:active)
    end

    it 'should have an element' do
      @account.should respond_to(:element)
    end

    it 'should only provide Asset, Liability, Equity, Revenue, and Expense in the list of elements' do
      Account::ELEMENTS.should eql(['Asset', 'Liability', 'Equity', 'Revenue', 'Expense'])
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

    it 'should order inactive accounts by name' do
      accounts = Account.inactive
      for i in (0...accounts.count - 1)
        accounts[i].name.should < accounts[i+1].name
      end
    end

    it 'should find active accounts' do
      Account.active.length.should == 10 
    end

    it 'should find active accounts by element' do
      accounts = Account.active
      accounts[0].should eql('Asset')
      accounts[1].count.should == 2 
      accounts[2].should eql('Liability')
      accounts[3].count.should == 3
      accounts[4].should eql('Equity')
      accounts[5].count.should == 2
      accounts[6].should eql('Revenue')
      accounts[7].count.should == 2
      accounts[8].should eql('Expense')
      accounts[9].count.should == 2
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

  describe 'memos' do
    before :each do
      @checking = Account.generate!(:name => 'checking', 
                                    :element => 'Asset',
                                    :initial_balance => 4000)
      arent = Account.generate!(:name => 'rent', :element => 'Expense')
      awate = Account.generate!(:name => 'water', :element => 'Expense')
      asavi = Account.generate!(:name => 'saving', :element => 'Asset')

      # Using explicit created_at to test order in which they are returned
      mrent = Memo.generate!(:text => 'rent 01/09', 
                             :created_at => Time.now + 1000)
      mwate = Memo.generate!(:text => 'water bill 01/09', 
                             :created_at => Time.now + 500)
      msavi = Memo.generate!(:text => 'saving 01/09')

      Entry.generate!(:memo => mrent,
                      :amount => 800,
                      :credit_account => arent,
                      :debit_account => @checking) 
      Entry.generate!(:memo => mwate,
                      :amount => 50,
                      :credit_account => awate,
                      :debit_account => @checking) 
      Entry.generate!(:memo => msavi,
                      :amount => 1000,
                      :credit_account => asavi,
                      :debit_account => @checking) 
      Entry.generate!(:memo => mrent,
                      :amount => 800,
                      :credit_account => arent,
                      :debit_account => @checking) 
    end

    it 'should find unique memos related to this account' do
      @checking.memos.length.should == 3
    end

    it 'should order memos by date descending' do
      for i in (0...@checking.memos.length - 1)
        @checking.memos[i].created_at.should > @checking.memos[i+1].created_at
      end
    end
  end
end
  
