class User
  generator_for :name, :start => 'Test User 1' do |prev|
    prev.succ
  end
end
