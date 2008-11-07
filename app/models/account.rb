class Account < ActiveRecord::Base
  has_many :entries

  named_scope :active,    :conditions => ['active = ?', true], :order => 'name'
  named_scope :inactive,  :conditions => ['active = ?', false], :order => 'name'
  
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :initial_balance
  validates_numericality_of :initial_balance, :greater_than_or_equal_to => 0.00

end
