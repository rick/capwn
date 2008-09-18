class User

  generator_for :login, :start => 'Login000' do |prev|
    prev.succ
  end
  generator_for :admin, true
  generator_for :name, :start => 'Name 000' do |prev|
    name, id = prev.split(/ /)
    "#{name} #{id.succ}"
  end
  generator_for :email, :start => 'email000@domain.com' do |prev|
    user, domain = prev.split(/@/)
    "#{user.succ}@#{domain}"
  end
  generator_for :password, :start => 'password000' do |prev|
    prev.succ
  end
  generator_for :password_confirmation, :start => 'password000' do |prev|
    prev.succ
  end
  generator_for :created_at do 
    5.days.ago 
  end
  generator_for :salt,       '7e3041ebc2fc05a40c60028e2c4901a81035d3cd'
end
