ActionController::Routing::Routes.draw do |map|

  # Walls controller
  map.with_options :controller => 'walls' do |wall_controller|
    wall_controller.resources :walls
    wall_controller.resources :events
    wall_controller.resources :profiles
    wall_controller.resources :conversations
    wall_controller.resources :locations
  end
  
  # map.resources :threads
  # map.resources :postings
  map.resources :messages, :collection => { :sent => :get } do |message|
    message.reply 'reply', :controller => 'messages', :action => 'reply', :conditions => { :method => :post }
  end

  # Welcome controller
  map.with_options :controller => 'welcome' do |welcome_controller|
    welcome_controller.welcome 'welcome',
        :action     => 'index',
        :conditions => { :method => :get  }
        
    welcome_controller.login 'login',
        :action     => 'login',
        :conditions => { :method => :post }
        
    welcome_controller.register 'signup',
        :action     => 'register',
        :conditions => { :method => :post }
    
    welcome_controller.lurk 'lurk', :action => 'lurk'
  end

  # User controller
  map.with_options :controller => 'users' do |users_controller|
    users_controller.resource :account
    users_controller.resource :profile
  end
  
  # map.resources :users, :except => [ :new, :create ]
  # map.resource :account, :controller => 'users'
  # map.profile  'profile', :controller => 'users', :action => 'show'

  # User session controller
  map.resources :user_sessions
  map.logout 'logout',
      :controller => 'user_sessions',
      :action     => 'destroy',
      :conditions => { :method => :get }
  
  map.root :controller => 'walls',
      :action     => 'index',
      :conditions => { :method => :get }
  
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

  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
