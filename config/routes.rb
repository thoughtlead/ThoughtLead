ActionController::Routing::Routes.draw do |map|
  
  map.resources :communities, :conditions => { :is_client_domain => false }

  map.login '/login', :controller => "sessions", :action => 'new', :conditions => { :is_client_domain => true }
  map.logout '/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :is_client_domain => true }
  map.signup '/signup', :controller => 'users', :action => 'signup', :conditions => { :is_client_domain => true }
  map.status '/status', :controller => 'home', :action => 'status', :conditions => { :is_client_domain => false }
  
  map.resources :themes, :conditions => { :is_client_domain => true }
  map.resources :sessions, :conditions => { :is_client_domain => true }
  map.resources :users, :member => { :email => :any, :edit_password => :any, :disable => :any, :reactivate => :any }, :conditions => { :is_client_domain => true }
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password', :conditions => { :is_client_domain => true }
  map.resources :discussions, :conditions => { :is_client_domain => true } do | discussions |
    discussions.resources :responses, :conditions => { :is_client_domain => true } 
  end
  map.resources :responses, :conditions => { :is_client_domain => true }
  
  map.resources :courses, :conditions => { :is_client_domain => true } do | courses |
    courses.resources :chapters, :conditions => { :is_client_domain => true } do | chapters |
      chapters.resources :lessons, :conditions => { :is_client_domain => true } do | lessons |
        lessons.resources :attachments, :conditions => { :is_client_domain => true }
      end
    end
  end
  
  map.resources :attachments, :conditions => { :is_client_domain => true } 
  
  map.search '/search', :controller=>"search", :action=>"index", :conditions => { :is_client_domain => true }
  
  map.root :controller => "home", :conditions => { :is_client_domain => false }
  map.community_home '', :controller => "communities", :action => 'current_community_home', :conditions => { :is_client_domain => true }
  map.community_need_to_activate '/need_to_activate', :controller => "communities", :action => 'need_to_activate', :conditions => { :is_client_domain => true }
  map.upgrade '/upgrade', :controller => "users", :action => 'upgrade', :conditions => { :is_client_domain => true }
  map.users_changed_on_spreedly '/changed_on_spreedly', :controller => "users", :action => 'changed_on_spreedly', :method => :post, :conditions => { :is_client_domain => true }
  map.discussions_for_theme '/discussions/theme/:id', :controller => "discussions", :action => "for_theme", :conditions => { :is_client_domain => true }
  
  map.edit_community '/community/edit', :controller => 'admin', :action => 'edit_community', :conditions => { :is_client_domain => true }
  map.access_rights '/community/access', :controller => 'admin', :action => 'access_rights', :conditions => { :is_client_domain => true }
  map.communities_changed_on_spreedly '/changed_on_spreedly', :controller => 'communities', :action => 'changed_on_spreedly', :method => :post, :conditions => { :is_client_domain => false }
  map.community_choose_plan '/choose_plan', :controller => 'communities', :action => 'choose_plan', :conditions => { :is_client_domain => false }
  
  map.library '/library', :controller => 'articles', :action => 'index', :conditions => { :is_client_domain => true }
  map.resources :articles, :conditions => { :is_client_domain => true }
  map.resources :categories, :conditions => { :is_client_domain => true }
  
end
