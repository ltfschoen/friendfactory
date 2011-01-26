Friskyfactory::Application.routes.draw do

  # To show waves
  namespace :wave do
    resources :communities, :only => [ :show ]
    resources :rollcalls,   :only => [ :index ], :controller => 'roll_calls', :as => 'roll_calls'
    resources :events,      :only => [ :index, :create ]
    resources :profiles,    :only => [ :show ] do      
      member { get 'photos' }
      get 'conversation' => 'conversations#show'
    end
    resources :conversations, :only => [ :index, :show ] do
      member do
        put 'close'
        get 'popup'
      end
    end
  end

  # To manage a user's profile
  scope :module => :wave do
    resource :profile, :only => [ :show, :edit, :update ], :controller => 'profile' do
      member { post 'avatar' }
    end
  end

  # To add postings to a wave
  resources :waves, :only => [] do
    namespace :posting do
      resources :texts,    :only => [ :new, :create ]
      resources :photos,   :only => [ :new, :create, :update, :destroy ]
      resources :post_its, :only => [ :new, :create ]
      resources :messages, :only => [ :create, :show ]
    end
  end

  # To add a comment to a posting
  resources :postings, :only => [] do |posting|
    scope :module => :posting do
      resources :comments, :only => [ :new, :create ]
    end
  end
  
  # To get geocoded location
  resources :locations, :only => [] do
    get 'geocode', :on => :collection
  end

  # To reset passwords
  resources :passwords, :only => [ :new, :create, :edit, :update ]  

  # User and User Sessions
  resources :users, :only => [ :new, :create ]  
  resources :user_sessions, :only => [ :new, :create, :destroy ] do
    get 'lurk', :on => :new
  end
  
  # Menu bar equivalents
  get   'login'   => 'user_sessions#create'  
  match 'logout'  => 'user_sessions#destroy', :via => [ :get, :delete ]
  get   'welcome' => 'welcome#index'
  get   'launch'  => 'welcome#launch'

  scope :module => 'wave' do
    get 'wave'            => 'communities#show'
    get 'rollcall(/:tag)' => 'roll_calls#index', :as => 'roll_call'
    get 'events(/:tag)'   => 'events#index', :as => 'events'
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
