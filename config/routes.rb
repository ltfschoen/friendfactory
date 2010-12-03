Friskyfactory::Application.routes.draw do

  # To show waves
  namespace :wave do
    resources :communities, :only => [ :show ]
    resources :rollcalls,   :only => [ :index ], :controller => 'roll_calls', :as => 'roll_calls'
    resources :events,      :only => [ :index, :create ]
    resources :profiles,    :only => [ :show ] do      
      member { get 'photos' }
      get  'conversation' => 'conversations#show'
    end
  end

  # Route to create conversation messages from a polaroid
  # when we only have the profile_id for the receiver.
  # namespace :posting { resources :messages, :only => [ :create ] }
  scope 'wave/profiles/:profile_id', :module => :posting do
    resources :messages, :only => [ :create ], :as => 'wave_profile_messages'
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
      resources :texts,    :only => [ :create ]
      resources :photos,   :only => [ :create ]
      resources :messages, :only => [ :create ]
    end
  end

  # To add a comment to a posting
  resources :postings, :only => [] do |posting|
    resources :comments, :only => [ :new, :create ], :controller => 'posting/comments'
  end

  # To reset passwords
  resources :passwords, :only => [ :new, :create, :edit, :update ]  

  # User and User Sessions
  resources :users, :only => [ :new, :create ]  
  resources :user_sessions, :only => [ :new, :create, :destroy ] do
    get 'lurk', :on => :new
  end
  
  # Menu bar equivalents
  get   'wave'            => 'wave/communities#show'
  get   'rollcall(/:tag)' => 'wave/roll_calls#index', :as => 'roll_call'
  get   'events'          => 'wave/events#index'
  get   'inbox'           => 'wave/conversations#index'
  get   'login'           => 'user_sessions#create'  
  match 'logout'          => 'user_sessions#destroy', :via => [ :get, :delete ]
  get   'welcome'         => 'welcome#index'
  get   ':slug',      :to => 'wave/communities#show', :constraints => { :slug => /\D\w*/ }
  root                :to => 'wave/communities#show', :via => :get

  # Labs
  if [ 'development', 'staging' ].include?(Rails.env)
    get 'labs/:action', :controller => 'labs'
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
