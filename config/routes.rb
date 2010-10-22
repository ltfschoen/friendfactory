ActionController::Routing::Routes.draw do |map|
  
  # # # # # # # # # # # # # # # 
  # Waves Controllers

  map.slug_wave 'waves/:slug', :controller => :waves, :action => :show,
      :requirements => { :slug => /\D\w*/ },
      :conditions   => { :method => :get  }

  map.resources :waves, :only => [ :index, :show, :create ] do |wave|
    # Used to add postings to a wave...
    wave.resources :texts,  :only => [ :create ]
    wave.resources :photos, :only => [ :create ]
    wave.resources :videos, :only => [ :create ]
    wave.resources :links,  :only => [ :create ]
  end

  map.wave_hotties 'hotties', :controller => :hotties, :action => :show, :conditions => { :method => :get }  
  map.resources :profiles, :only => [ :show, :edit, :update ]
  
  # # # # # # # # # # # # # # # 
  
  map.edit_profile 'profile', :controller => 'profiles', :action => 'edit', :conditions => { :method => :get }
  
  # # # # # # # # # # # # # # # 
  # Postings Controllers

  map.namespace(:posting) do |posting|
    posting.resources :chats
  end
  
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

  # map.resources :chats, :only => [ :index ]  
  map.resources :users, :only => [ :new, :create ]
  map.resources :friendships, :only => [ :create, :destroy ]

  map.resources :user_sessions, :only => [ :new, :create, :destroy ], :new => { :lurk => :get }  
  map.login  'login',  :controller => 'user_sessions', :action => 'create',  :conditions => { :method => :get }
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy', :conditions => { :method => :delete }
  
  map.search 'search', :controller => 'search', :action => 'index', :conditions => { :method => :get }
    
  map.welcome 'welcome', :controller => 'welcome', :action => 'index', :conditions => { :method => :get }
  
  map.root :wave
  
  # # # # # # # # # # # # # # # 
  # Miscellaneous
    
  map.labs 'labs/:action', :controller => 'labs', :conditions => { :method => :get }
  # map.peek 'peek', :controller => 'welcome', :action => 'peek'  # Chat Debug
  
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
