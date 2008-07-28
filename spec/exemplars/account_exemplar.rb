class Account
  generator_for :name, :start => 'Test Account 1' do |prev|
    prev.succ
  end
end
