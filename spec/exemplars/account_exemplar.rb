class Account
  generator_for :name, :start => 'Test Account 1' do |prev|
    prev.succ
  end
  generator_for :initial_balance, rand(99999)
  generator_for :active, true
end
