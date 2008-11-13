class Memo
  generator_for :text     => Time.now.to_s
  generator_for :paid_at  => Time.now
end
