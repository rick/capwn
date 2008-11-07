class Entry < ActiveRecord::Base
  belongs_to :debit_account,  :class_name => "Account"
  belongs_to :credit_account, :class_name => "Account"
  belongs_to :transaction
  
  validates_presence_of :debit_account, :credit_account, :amount, :transaction
end
