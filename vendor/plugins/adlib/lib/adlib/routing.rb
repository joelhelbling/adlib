class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|
  map.resource :adlib_session, :path_prefix => 'adlib', :as => 'session'

  map.resources :adlib_pages, :path_prefix => 'adlib', :as => 'pages' do |pages|
    pages.resources :adlib_snippets, :as => 'snippets'
    pages.resources :adlib_images, :as => 'images'
  end

  map.connect '*path', :controller => 'adlib_pages', :action => 'show'  
end
