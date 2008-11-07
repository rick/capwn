namespace :bootstrap do
  desc "Add the default user"
  task :user => :environment do
    User.create(:name => 'user', 
                :login => 'user', 
                :password => 'user99',
                :password_confirmation => 'user99',
                :email => 'user@capwn.com',
                :admin => true)
  end
end
