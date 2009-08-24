ActionController::Routing::Routes.draw do |map|
  map.resources :pages, :conditions => { :is_client_domain => true }

  map.resource :session, :controller => 'session', :conditions => { :is_client_domain => true }

  map.login '/login', :controller => "session", :action => 'new', :conditions => { :is_client_domain => true }
  map.logout '/logout', :controller => 'session', :action => 'destroy', :conditions => { :is_client_domain => true }

  map.resource :subscription, :controller => 'subscription', :conditions => { :is_client_domain => true }
  map.resource :billing_information, :controller => 'billing_information', :conditions => { :is_client_domain => true }

  map.upgrade '/upgrade', :controller => "subscription", :action => 'edit', :conditions => { :is_client_domain => true }

  map.resources :communities, :conditions => { :is_client_domain => false }
  map.communities '/communities', :controller => "communities", :action => 'index', :conditions => { :is_client_domain => true }
  map.communities_activate '/communities/toggle_activation/:id', :controller => "communities", :action => 'toggle_activation', :conditions => { :is_client_domain => true }

  map.setup '/getting-started/:action/:id', :controller => "setup", :conditions => { :is_client_domain => false }

  map.community_home '', :controller => "communities", :action => 'current_community_home', :conditions => { :is_client_domain => true }
  map.community_about '/about', :controller => "communities", :action => 'current_community_about', :conditions => { :is_client_domain => true }
  map.community_contact '/contact', :controller => "communities", :action => 'current_community_contact', :conditions => { :is_client_domain => true }
  map.community_tos '/tos', :controller => "communities", :action => 'current_community_tos', :conditions => { :is_client_domain => true }
  map.community_need_to_activate '/need_to_activate', :controller => "communities", :action => 'need_to_activate', :conditions => { :is_client_domain => true }

  map.signup '/signup', :controller => 'users', :action => 'signup', :conditions => { :is_client_domain => true }
  map.status '/status', :controller => 'home', :action => 'status', :conditions => { :is_client_domain => false }

  map.resources :subscription_payments, :conditions => { :is_client_domain => true }

  map.resources :users, :as => 'members', :member => { :email => :any, :edit_password => :any, :disable => :any, :reactivate => :any }, :conditions => { :is_client_domain => true } do |users|
    users.resources :subscription_payments, :conditions => { :is_client_domain => true }
  end

  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password', :conditions => { :is_client_domain => true }

  # the shallow nested route for discussions below doesn't give us discussions_path, only discussion_path.
  # Similarly, we don't get new_discussion_path, only new_theme_discussion_path.
  # So we need to declare those here.  This has to come before the routes below.
  map.resources :discussions, :only => [:new, :create, :index], :collection => { :uncategorized => :get }, :conditions => { :is_client_domain => true }

  map.resources :themes, :shallow => true, :collection => { :sort => :post }, :conditions => { :is_client_domain => true } do |themes|
    themes.resources :discussions, :conditions => { :is_client_domain => true } do |discussions|
      discussions.resources :responses, :conditions => { :is_client_domain => true }
      discussions.resources :email_subscriptions, :conditions => { :is_client_domain => true }
    end
  end

  map.resources :courses, :shallow => true, :collection => { :sort => :post }, :conditions => { :is_client_domain => true } do |courses|
    courses.resources :chapters, :collection => { :sort => :post }, :conditions => { :is_client_domain => true } do |chapters|
      chapters.resources :lessons, :collection => { :sort => :post }, :conditions => { :is_client_domain => true } do |lessons|
        lessons.resources :attachments, :conditions => { :is_client_domain => true }
      end
    end
  end

  map.resources :attachments, :conditions => { :is_client_domain => true }

  map.search '/search', :controller=>"search", :action=>"index", :conditions => { :is_client_domain => true }

  map.root :controller => "home", :conditions => { :is_client_domain => false }

  map.edit_community '/community/edit', :controller => 'admin', :action => 'edit_community', :conditions => { :is_client_domain => true }
  map.access_levels '/community/access', :controller => 'admin', :action => 'access_levels', :conditions => { :is_client_domain => true }
  map.create_access_level '/community/create_access', :controller => 'admin', :action => 'create_access_level', :conditions => { :is_client_domain => true }
  map.select_exported_users '/community/select_exported_users', :controller => 'admin', :action => 'select_exported_users', :conditions => { :is_client_domain => true }
  map.select_affiliate_reports '/community/affiliate_reporting', :controller => 'admin', :action => 'select_affiliate_reports', :conditions => { :is_client_domain => true }

  map.export_users '/community/export_users', :controller => 'admin', :action => 'export_users', :conditions => { :is_client_domain => true }
  map.export_users '/community/export_affiliates', :controller => 'admin', :action => 'export_affiliates', :conditions => { :is_client_domain => true }

  map.resources :access_classes, :conditions => { :is_client_domain => true } do |access_classes|
    access_classes.resources :subscription_plans, :conditions => { :is_client_domain => true }
  end
  
  map.media_upload '/media/:id/upload', :controller => 'media', :action => 'upload'
  map.media_done '/media/:id/done', :controller => 'media', :action => 'done'
  map.media_status '/media/:id/status', :controller => 'media', :action => 'status', :conditions => { :method => :post }
  
  
  map.library '/library', :controller => 'articles', :action => 'index', :conditions => { :is_client_domain => true }
  map.resources :articles, :conditions => { :is_client_domain => true }
  map.resources :categories, :collection => { :sort => :post }, :conditions => { :is_client_domain => true }
  
  map.catch_all '*path', :controller => 'pages', :action => 'catchall'
end
