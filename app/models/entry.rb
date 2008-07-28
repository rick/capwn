class Entry < ActiveRecord::Base
  belongs_to :account
  belongs_to :transaction
  
  validates_presence_of :account, :amount, :transaction
end
