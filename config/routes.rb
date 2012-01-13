Friskyfactory::Application.routes.draw do

  # To show waves
  namespace :wave do
    get ':id/rollcall(/:tag)' => 'communities#rollcall', :as => 'rollcall'

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
        get :location
      end
      get 'conversation' => 'conversations#show'
    end

    resources :ambassadors, :only => [ :show ]

    resources :conversations, :only => [ :index, :show ] do
      member do
        put :close
        get :popup
      end
    end

    resources :albums, :only => [ :index, :show, :new, :create ] # do
      # resources :photos, :only => [ :show ], :controller => 'albums'
    # end
    
    resources :places, :only => [ :show ]
  end

  scope :module => :wave do
    put 'waves/:id/unpublish' => 'waves#unpublish', :as => 'unpublish_wave'
  end

  # Headshots
  resource :profile, :only => [ :show, :edit, :update ],
      :controller => 'headshots' do
    member do
      post :avatar
      put  :unsubscribe
    end
  end
  
  # Personages
  resource :personages, :only => [] do
    put :switch, :on => :member
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
        get 'avatar/comments' => 'avatars#comments'
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

  # Welcome
  namespace :welcome do
    get 'headshot/:pane', :action => 'headshot', :as => 'headshot'
    get '(/:invitation_code)', :action => 'show'
    post 'signup'
    post 'login'
  end

  post 'launch' => 'welcome#launch'
  match 'logout' => 'user_sessions#destroy', :via => [ :get, :delete ]

  # Reset passwords
  resources :passwords, :only => [ :new, :create, :edit, :update ]

  resources :user_sessions, :only => [ :destroy ] do
    get 'lurk', :on => :new
  end

  scope :module => 'wave' do
    get 'wave' => 'communities#show' # TODO Remove
    get 'events(/:tag)' => 'events#index', :as => 'events' # TODO Remove
    get 'invitations' => 'invitations#index'
    get 'inbox' => 'conversations#index'
    get ':slug', :to => 'communities#show', :constraints => { :slug => /\D\w*/ }
    root :to => 'communities#show', :via => :get
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

    resources :sites, :except => [ :show, :destroy ] do
      resources :users, :only => [ :index, :update ]
    end
  end

  get 'stylesheets/:site_name(/:controller_name).:format' => 'admin/sites#stylesheets'

end
