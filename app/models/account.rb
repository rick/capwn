class Account < ActiveRecord::Base
  has_many :debit_entries, :class_name => "Entry", :foreign_key => "debit_account_id"
  has_many :credit_entries, :class_name => "Entry", :foreign_key => "credit_account_id"

  named_scope :active,    :conditions => ['active = ?', true], :order => 'name'
  named_scope :inactive,  :conditions => ['active = ?', false], :order => 'name'
  
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :initial_balance
  validates_numericality_of :initial_balance, :greater_than_or_equal_to => 0.00

  def entries
    Entry.find :all, 
      :conditions => ["debit_account_id = ? OR credit_account_id = ?", self.id, self.id]
  end

end
