class Account
  generator_for :name, :start => 'Test Account 1' do |prev|
    prev.succ
  end
  generator_for :initial_balance, :method => :random_balance
  generator_for :active, true
  generator_for :element, 'Asset'

  def self.random_balance
    rand(9999)
  end
end
