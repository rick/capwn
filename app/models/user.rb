class User < ActiveRecord::Base
  has_many :transactions
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
