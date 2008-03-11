ActionController::Routing::Routes.draw do |map|
  map.resources :lessons

  map.signup '/signup', :controller => "users", :action => 'signup'
  map.login '/login', :controller => "sessions", :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.resources :courses
  map.resources :sessions
  map.resources :users
  map.root :controller => "home"

end
