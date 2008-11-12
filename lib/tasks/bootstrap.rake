task :bootstrap => :environment do

  # Create User
  u = User.generate(:name => 'user', 
                    :login => 'user', 
                    :password => 'user99',
                    :password_confirmation => 'user99',
                    :email => 'user@capwn.com',
                    :admin => true)

  # Create Accounts
  income    = Account.generate(:name => 'Income')
  checking  = Account.generate(:name => 'Checking')
  taxes     = Account.generate(:name => 'Taxes')
  groceries = Account.generate(:name => 'Groceries')

  # Create Transactions/Entries
  t1   = Transaction.generate(:memo => 'Paycheck',
                             :user => u)

  t1e1 = Entry.generate(:amount         => 80,
                        :debit_account  => income,
                        :credit_account => checking,
                        :transaction    => t1)
  t1e2 = Entry.generate(:amount         => 20,
                        :debit_account  => income,
                        :credit_account => taxes,
                        :transaction    => t1)

  t2   = Transaction.generate(:memo => 'Buy Groceries',
                              :user => u)

  t2e1 = Entry.generate(:debit_account  => checking,
                        :credit_account => groceries,
                        :transaction    => t2)
end
