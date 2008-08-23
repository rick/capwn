class Account < ActiveRecord::Base
  has_many :entries
  
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :initialBalance
end
