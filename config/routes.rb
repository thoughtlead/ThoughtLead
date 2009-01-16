ActionController::Routing::Routes.draw do |map|
  map.resources :communities, :conditions => { :is_client_domain => false }
  map.communities '/communities', :controller => "communities", :action => 'index', :conditions => { :is_client_domain => true }
  map.communities_activate '/communities/toggle_activation/:id', :controller => "communities", :action => 'toggle_activation', :conditions => { :is_client_domain => true }

  map.community_home '', :controller => "communities", :action => 'current_community_home', :conditions => { :is_client_domain => true }
  map.community_about '/about', :controller => "communities", :action => 'current_community_about', :conditions => { :is_client_domain => true }
  map.community_contact '/contact', :controller => "communities", :action => 'current_community_contact', :conditions => { :is_client_domain => true }
  map.community_tos '/tos', :controller => "communities", :action => 'current_community_tos', :conditions => { :is_client_domain => true }
  map.community_need_to_activate '/need_to_activate', :controller => "communities", :action => 'need_to_activate', :conditions => { :is_client_domain => true }

  map.login '/login', :controller => "sessions", :action => 'new', :conditions => { :is_client_domain => true }
  map.logout '/logout', :controller => 'sessions', :action => 'destroy', :conditions => { :is_client_domain => true }
  map.signup '/signup', :controller => 'users', :action => 'signup', :conditions => { :is_client_domain => true }
  map.status '/status', :controller => 'home', :action => 'status', :conditions => { :is_client_domain => false }

  map.resources :themes, :conditions => { :is_client_domain => true }
  map.resources :sessions, :conditions => { :is_client_domain => true }

  map.resources :users, :as => 'members', :member => { :email => :any, :edit_password => :any, :disable => :any, :reactivate => :any }, :conditions => { :is_client_domain => true }

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

  map.upgrade '/upgrade', :controller => "users", :action => 'upgrade', :conditions => { :is_client_domain => true }
  map.discussions_for_theme '/discussions/theme/:id', :controller => "discussions", :action => "for_theme", :conditions => { :is_client_domain => true }

  map.edit_community '/community/edit', :controller => 'admin', :action => 'edit_community', :conditions => { :is_client_domain => true }
  map.access_levels '/community/access', :controller => 'admin', :action => 'access_levels', :conditions => { :is_client_domain => true }
  map.create_access_level '/community/create_access', :controller => 'admin', :action => 'create_access_level', :conditions => { :is_client_domain => true }
  map.select_exported_users '/community/select_exported_users', :controller => 'admin', :action => 'select_exported_users', :conditions => { :is_client_domain => true }
  map.export_users '/community/export_users', :controller => 'admin', :action => 'export_users', :conditions => { :is_client_domain => true }

  map.resources :access_classes, :conditions => { :is_client_domain => true } do |access_classes|
    access_classes.resources :subscription_plans, :conditions => { :is_client_domain => true }
  end

  map.library '/library', :controller => 'articles', :action => 'index', :conditions => { :is_client_domain => true }
  map.resources :articles, :conditions => { :is_client_domain => true }
  map.resources :categories, :conditions => { :is_client_domain => true }
end