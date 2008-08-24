class Account < ActiveRecord::Base
  has_many :entries
  
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :initialBalance
  validates_numericality_of :initialBalance, :greater_than_or_equal_to => 0.00

  def initial_balance
    initialBalance.to_s('F')
  end
end
