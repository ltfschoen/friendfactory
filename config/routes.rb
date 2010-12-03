Friskyfactory::Application.routes.draw do |map|

  namespace :wave do
    resource :communities, :only => [ :show ]
  end

  # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # 

  # To manage a user's profile
  resource :profile, :only => [ :show, :edit, :update ], :controller => 'waves/profile' do
    member { post 'avatar' }
  end

  # To show waves
  namespace :waves do
    resources :profiles, :only => [ :show ] do
      member { get :photos }
    end
    get ':slug' => 'base#show', :as => 'slug', :constraints => { :slug => /\D\w*/ }
  end

  get 'rollcall(/:tag)', :controller => 'waves/roll_calls', :action => :index, :as => 'rollcall'

  # To show events
  namespace :wave do
    resources :events, :only => [ :index, :create ]
  end
  
  get 'events', :controller => 'wave/events', :action => 'index'

  # To add postings to a wave
  resources :waves, :only => [] do
    namespace :postings do
      resources :texts, :only => [ :create ]
      resources :photos, :only => [ :create ]
      resources :messages, :only => [ :create ]
    end
  end
  
  # Route to create conversation messages from a polaroid
  # when we only have the profile_id for the receiver.
  namespace :postings do
    resources :messages, :only => [ :create ]
  end

  # Route to show conversation messages from a polaroid
  # when we only have the profile_id of the receiver.
  get 'profile/:profile_id/conversation', :controller => 'waves/conversations', :action => 'show'
  
  get 'inbox', :controller => 'waves/conversations', :action => :index

  # To add a comment to a posting
  map.resources :postings, :only => [] do |posting|
    posting.resources :comments, :only => [ :new, :create ], :controller => 'postings/comments'
  end

  # To reset passwords
  resources :passwords, :only => [ :new, :create, :edit, :update ]  

  # # # # # # # # # # # # # # #
  # # # # # # # # # # # # # # # 

  map.resources :waves, :only => [ :index, :show, :create ], :controller => 'waves/base' do |wave|
    # Used to add postings to a wave...
    # wave.resources :videos, :only => [ :create ]
    # wave.resources :links,  :only => [ :create ]
  end
    
  # # # # # # # # # # # # # # # 
  # Postings Controllers

  # map.namespace(:posting) do |posting|
  #   posting.resources :chats
  # end
  
  map.resources :avatars, :only => [ :create ] # TODO: remove once profiles wave works correctly

  # TODO: Use a manual mapping
  # map.resources :messages, :only => [] do |message|
  #   message.resource 'reply', :only => [ :create ], :controller => 'messages'
  # end

  # # # # # # # # # # # # # # # 

  # map.resources :chats, :only => [ :index ]  
  map.resources :users, :only => [ :new, :create ]
  # map.resources :friendships, :only => [ :create, :destroy ]

  map.resources :user_sessions, :only => [ :new, :create, :destroy ], :new => { :lurk => :get }  
  map.login  '/login',  :controller => 'user_sessions', :action => 'create',  :conditions => { :method => :get }
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy', :conditions => { :method => [ :get, :delete ] }  
  map.search '/search', :controller => 'search', :action => 'index', :conditions => { :method => :get }
  
  map.welcome '/welcome', :controller => 'welcome', :action => 'index', :conditions => { :method => :get }

  # Catch-all
  get '/:slug', :to => 'wave/communities#show', :constraints => { :slug => /\D\w*/ }
  root          :to => 'wave/communities#show', :via => :get

  # Labs
  if [ 'development', 'staging' ].include?(Rails.env)
    map.labs 'labs/:action', :controller => 'labs', :conditions => { :method => :get }
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
