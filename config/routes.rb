ActionController::Routing::Routes.draw do |map|
  
  map.resources :waves, :collection => { :popular => :get }
  # map.resources :postings
  
  # Profiles controller
  map.resources :profiles, :except => [ :index, :new, :edit, :destroy ]
  map.edit_profile '/profile', :controller => 'profiles', :action => 'edit'

  # User Controller
  map.with_options :controller => 'users' do |users_controller|
    users_controller.resources :users
    users_controller.resource  :account
  end

  map.resources :friendships, :only => [ :create, :destroy ]
  
  # Messages Controller
  map.resources :messages, :collection => { :sent => :get } do |message|
    message.reply 'reply',
        :controller => 'messages',
        :action     => 'reply',
        :conditions => { :method => :post }
  end

  # Welcome Controller
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

  # UserSession Controller
  map.resources :user_sessions
  map.logout 'logout',
      :controller => 'user_sessions',
      :action     => 'destroy',
      :conditions => { :method => :get }
  
  map.peek 'peek', :controller => 'welcome', :action => 'peek'
  
  map.root :controller => 'waves',
      :action     => 'popular',
      :conditions => { :method => :get }
  
  
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
