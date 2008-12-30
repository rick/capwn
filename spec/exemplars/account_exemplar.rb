class Account
  generator_for :name, :start => 'Test Account 000' do |prev|
    prev.succ
  end
  generator_for :initial_balance, :method => :random_balance
  generator_for :active, true
  generator_for :element, :method => :random_element

  def self.random_balance
    rand(9999)
  end

  def self.random_element
    elements = ['Asset', 'Liability', 'Equity', 'Revenue', 'Expense']
    elements[rand(elements.size)]
  end
end
