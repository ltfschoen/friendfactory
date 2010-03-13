ActionController::Routing::Routes.draw do |map|

  # Welcome controller
  map.with_options :controller => 'welcome' do |welcome|
    welcome.login    'login',   :action => 'index',    :conditions => { :method => :get  }
    welcome.login    'login',   :action => 'login',    :conditions => { :method => :post }
    welcome.register 'signup',  :action => 'register', :conditions => { :method => :post }
  end

  # User controller
  map.resources :users, :except => [ :new, :create ]
  # map.resource  :account, :controller => 'users'

  # User session controller
  map.resources :user_sessions
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy', :conditions => { :method => :get }
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  map.root :controller => 'home', :action => 'index', :conditions => { :method => :get }

  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
