Friskyfactory::Application.routes.draw do

  # To show waves
  namespace :wave do
    resources :communities, :only => [ :show ] do
      member do
        get :rollcall
      end
    end
    resources :events, :only => [ :index, :show, :new, :create ]
    resources :profiles, :only => [ :index, :show ] do
      member do
        get :signals
        get :biometrics        
        get :photos
        get :invitations
        get :conversation
        get :pokes
      end
      get 'conversation' => 'conversations#show'
    end    
    resources :conversations, :only => [ :index, :show ] do
      member do
        put :close
        get :popup
      end
    end    
    resources :albums, :only => [ :index, :show, :new, :create ] # do
      # resources :photos, :only => [ :show ], :controller => 'albums'
    # end
  end

  # To manage a user's profile
  scope :module => :wave do
    resource :profile, :only => [ :show, :edit, :update ], :controller => 'profile' do
      member do
        post :avatar
        put :unsubscribe
      end
    end
  end

  # To add postings to a wave
  resources :waves, :only => [] do
    namespace :posting do
      resources :texts,        :only => [ :new, :create ]
      resources :photos,       :only => [ :new, :create, :update, :destroy ]
      resources :post_its,     :only => [ :new, :create ]
      resources :videos,       :only => [ :new, :create ]
      resources :messages,     :only => [ :show, :create ]
      resources :wave_proxies, :only => [ :create ]
      resources :invitations,  :only => [ :new, :create, :edit, :update ]
      resources :links,        :only => [ :new, :create ]
    end
  end

  # To manage a posting
  scope :module => :posting do
    resources :postings, :only => [] do |posting|
      member do
        delete :unpublish, :controller => 'base'
      end
      collection do
        get :fetch, :controller => 'base'
      end
      # To manage children of a posting
      resources :comments, :only => [ :index, :new, :create ]
    end
  end
  
  # Friendships
  resources :friendships, :only => [] do
    collection do
      get :pokes
      get :admirers
    end
    new do
      put ':id/buddy',:action => :buddy , :as => 'buddy'
      post :poke
    end
  end

  get 'buddies' => 'friendships#index'

  # To get geocoded location
  resources :locations, :only => [] do
    get 'geocode', :on => :collection
  end

  # To reset passwords
  resources :passwords, :only => [ :new, :create, :edit, :update ]  

  # User and User Sessions
  resources :users, :only => [ :create, :update ] do
    get 'member', :on => :collection
  end
  
  resources :user_sessions, :only => [ :new, :create, :destroy ] do
    get 'lurk', :on => :new
  end
  
  # Menu bar equivalents
  get   'login'   => 'user_sessions#create'  
  match 'logout'  => 'user_sessions#destroy', :via => [ :get, :delete ]
  
  # Welcome  
  # resource 'welcome', :only => [ :show ], :controller => 'welcome'
  get  'welcome(/:invite)' => 'welcome#show', :as => 'welcome'
  post 'launch' => 'welcome#launch'

  scope :module => 'wave' do
    get 'wave'            => 'communities#show'
    get 'rollcall(/:tag)' => 'profiles#index', :as => 'roll_call'
    get 'events(/:tag)'   => 'events#index', :as => 'events'
    get 'invitations'     => 'invitations#index'
    get 'inbox'           => 'conversations#index'
    get ':slug',      :to => 'communities#show', :constraints => { :slug => /\D\w*/ }
    root              :to => 'communities#show', :via => :get
  end

  # Labs
  if [ 'development', 'staging' ].include?(Rails.env)
    get 'labs/:action' => 'labs'
  end
  
  # Admin  
  namespace :admin do
    resources :tags, :except => [ :show ] do
      collection { get 'commit' }
    end
    namespace :invitation do
      resources :universals, :only => [ :index, :new, :create, :edit, :update, :destroy ]
      resources :personals, :only => [ :index ]
    end
    resources :sites, :only => [ :index, :new, :create, :edit, :update ]
  end
  
  get 'stylesheets/:site_name(/:controller_name).:format' => 'admin/sites#stylesheets'
    
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
