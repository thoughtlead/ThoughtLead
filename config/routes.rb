ActionController::Routing::Routes.draw do |map|

  map.login '/login', :controller => "sessions", :action => 'new', :conditions => { :subdomain => /./ }
  map.logout '/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :subdomain => /./ }
  map.signup '/signup', :controller => 'users', :action => 'signup', :conditions => { :subdomain => /./ }

  map.resources :communities, :conditions => { :subdomain => '' }
  map.resources :courses, :has_many => :articles
  map.resources :sessions
  map.resources :users

  map.root :controller => "home", :conditions => { :subdomain => '' }
  map.community_home '', :controller => "communities", :action => 'show', :conditions => { :subdomain => /./ }

end
