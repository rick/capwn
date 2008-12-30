ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users

  map.resource :session


  map.resources :accounts, :collection =>{:inactive => :get}, :member => {:journal => :get}
  map.resources :journals

  map.resources :categories

  map.root :controller => 'accounts', :action => 'index', :resource_path => '/accounts'
end
