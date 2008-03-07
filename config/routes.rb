ActionController::Routing::Routes.draw do |map|
  map.resources :customers


  map.root :controller => "home"

end
