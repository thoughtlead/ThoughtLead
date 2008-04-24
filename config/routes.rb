ActionController::Routing::Routes.draw do |map|

  map.resources :communities, :conditions => { :subdomain => '' }

  map.login '/login', :controller => "sessions", :action => 'new', :conditions => { :subdomain => /./ }
  map.logout '/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :subdomain => /./ }
  map.signup '/signup', :controller => 'users', :action => 'signup', :conditions => { :subdomain => /./ }

  map.resources :sessions, :conditions => { :subdomain => /./ }
  map.resources :users, :member => { :email => :any, :edit_password => :any }, :conditions => { :subdomain => /./ }
  map.resources :discussions, :conditions => { :subdomain => /./ } do | discussions |
    discussions.resources :responses, :conditions => { :subdomain => /./ } 
  end
  
  map.resources :courses, :conditions => { :subdomain => /./ } do | courses |
    courses.resources :chapters, :conditions => { :subdomain => /./ } do | chapters |
      chapters.resources :lessons, :conditions => { :subdomain => /./ }
    end
  end

  map.root :controller => "home", :conditions => { :subdomain => '' }
  map.community_home '', :controller => "courses", :action => 'index', :conditions => { :subdomain => /./ }
  map.community_need_to_activate 'need_to_activate', :controller => "communities", :action => 'need_to_activate', :conditions => { :subdomain => /./ }
  map.upgrade '/upgrade', :controller => "users", :action => 'upgrade', :conditions => { :subdomain => /./ }
  map.users_changed_on_spreedly '/changed_on_spreedly', :controller => "users", :action => 'changed_on_spreedly', :method => :post, :conditions => { :subdomain => /./ }

  map.edit_community '/community/edit', :controller => 'admin', :action => 'edit_community', :conditions => { :subdomain => /./ }
  map.communities_changed_on_spreedly '/changed_on_spreedly', :controller => 'communities', :action => 'changed_on_spreedly', :method => :post, :conditions => { :subdomain => '' }
  map.community_choose_plan '/choose_plan', :controller => 'communities', :action => 'choose_plan', :conditions => { :subdomain => '' }
end
