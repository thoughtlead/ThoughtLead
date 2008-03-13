ActionController::Routing::Routes.draw do |map|

  # map.login '/login', :controller => "sessions", :action => 'new'
  # map.logout '/logout', :controller => 'sessions', :action => 'destroy'

  map.resources :communities
  map.resources :articles
  map.resources :sessions
  map.resources :users
  map.root :controller => "home"

end
