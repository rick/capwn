class Account < ActiveRecord::Base
  has_many :entries

  named_scope :active,    :conditions => ['active = ?', true], :order => 'name'
  named_scope :inactive,  :conditions => ['active = ?', false], :order => 'name'
  
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_presence_of :initialBalance
  validates_numericality_of :initialBalance, :greater_than_or_equal_to => 0.00

  def formatted_initial_balance
    n = sprintf("%.2f", self.initialBalance)
    n.to_s =~ /([^\.]*)(\..*)?/
    int, dec = $1.reverse, $2 ? $2 : ""
    while int.gsub!(/(,|\.|^)(\d{3})(\d)/, '\1\2,\3')
    end
    int.reverse + dec

  end
end
