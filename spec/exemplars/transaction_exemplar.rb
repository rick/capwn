class Transaction
  generator_for :memo     => Time.now.to_s
  generator_for :paid_at  => Time.now
end
