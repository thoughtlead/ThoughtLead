ActionController::Routing::Routes.draw do |map|

  map.signup '/signup', :controller => "users", :action => 'signup'
  map.login '/login', :controller => "sessions", :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password '/login/forgot_password', :controller => 'sessions', :action => 'forgot_password'
  map.reset_password 'rp/:reset_password_token', :controller => "sessions", :action => 'reset_password'


  map.resources :users
  map.root :controller => "home"

end
