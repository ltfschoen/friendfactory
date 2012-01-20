Friskyfactory::Application.routes.draw do

  root :to => redirect { |params, request|
    site_name = request.domain && request.domain.gsub(/\..*$/, '')
    if site = Site.find_by_name(site_name)
      wave = site.home_wave
      type = wave.class.name.demodulize.downcase.pluralize
      "/wave/#{type}/#{wave.id}"
    end
  }

  get '/stylesheets/:site_name(/:controller_name).:format' => 'admin/sites#stylesheets'


  # Waves
  namespace :wave do
    resources :communities, :only => [ :show ] do
      get :rollcall, :path => 'rollcall(/:tag)', :on => :member
    end

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

    resources :places, :only => [ :show ] do
      get :rollcall, :path => 'rollcall(/:tag)', :on => :member
    end

    resources :conversations, :only => [ :index, :show ] do
      member do
        put :close
        get :popup
      end
    end

    resources :albums, :only => [ :index, :show, :new, :create ]
    # resources :events, :only => [ :index, :show, :new, :create ]
  end


  # Basic Wave Functions
  scope :module => :wave do
    resources :waves, :only => [] do
      member do
        put :unpublish
        # get :conversation
      end
    end
    get :inbox, :to => 'conversations#index'
    # get ':slug', :to => 'communities#show', :constraints => { :slug => /\D\w*/ }
  end


  # Waves' Postings
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


  # Personages and Headshots
  resources :profiles, :only => [ :show, :new, :edit, :update ], :controller => 'personages' do
    member do
      post :avatar
      put  :unsubscribe
      put  :switch
    end
  end

  get ':persona_type' => 'personages#index',
      :constraints => { :persona_type => /ambassadors|communities|places/ },
      :as => 'persona_type_profiles'

  resource :profile, :only => [ :show ],
      :controller => 'personages',
      :as => 'current_profile'


  # Postings
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


  # Geocode
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
      resources :users, :only => [ :index, :show, :update ]
    end
  end

end
