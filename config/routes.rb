ActionController::Routing::Routes.draw do |map|
  
  # Waves Controllers
  map.resources :waves, :only => [ :index, :show, :create ] do |wave|
    # Following used to add postings to a wave.
    wave.resources :texts,  :only => [ :create ]
    wave.resources :photos, :only => [ :create ]
    wave.resources :videos, :only => [ :create ]
  end

  map.wave_hotties '/hotties',
      :controller => :hotties,
      :action     => :show,
      :conditions => { :method => :get }

  map.resources :profiles,
      :only   => [ :show, :edit, :update ],
      :member => { :home => :get } do |profile|
    profile.photos 'photos',
        :controller => 'profiles',
        :action     => 'photo',
        :conditions => { :method => :post } 
  end

  map.edit_profile '/profile',
      :controller => 'profiles',
      :action     => 'edit',
      :conditions => { :method => :get }
  
  # # # # # # # # # # # # # # #
  
  # Postings Controllers
  map.resources :avatars,  :only => [ :create ] # TODO: remove once profiles wave works correctly

  # TODO: Use a manual mapping
  map.resources :postings, :only => [] do |posting|
    posting.resources :comments, :only => [ :create ]
  end

  # TODO: Use a manual mapping
  map.resources :messages, :only => [] do |message|
    message.resource 'reply', :only => [ :create ], :controller => 'messages'
  end

  # # # # # # # # # # # # # # #
  
  # User Controller
  map.with_options :controller => 'users' do |users_controller|
    users_controller.resources :users
    users_controller.resource  :account
  end

  # Friendships Controller
  map.resources :friendships, :only => [ :create, :destroy ]

  # # # # # # # # # # # # # # #
  
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
  
  map.search 'search',
      :controller => 'search',
      :action     => 'index'
  
  # Root Controller
  map.root :controller => 'waves',
      :action     => 'show',
      :conditions => { :method => :get }

  # Chat Debug
  map.peek 'peek', :controller => 'welcome', :action => 'peek'  
  
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
