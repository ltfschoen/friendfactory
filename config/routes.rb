# require 'sti'

Friskyfactory::Application.routes.draw do

  root :to => redirect { |params, request|
    # load 'sti.rb' if Rails.env.development?
    site_name = request.domain && request.domain.gsub(/\..*$/, '')
    if site = Site.find_by_name(site_name)
      wave = site.home_wave
      type = wave.class.name.demodulize.downcase.pluralize
      "/wave/#{type}/#{wave.id}"
    end
  }

  get '/stylesheets/:site_name(/:controller_name).:format' => 'admin/sites#stylesheets'

  get '/h/:hash_key(/:style)' => 'posting/postings#show'

  # Waves
  namespace :wave do
    resources :communities, :only => [ :show ] do
      get :rollcall, :path => 'rollcall(/:tag)', :on => :member
    end
    resources :profiles, :only => [ :index, :show ]
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

  # Wave Functions
  scope :module => :wave do
    resources :waves, :only => [] do
      member do
        put :unpublish
      end
    end
    get 'inbox(/:tag)', :to => 'conversations#index', :as => 'inbox'
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

  # Posting Functions
  namespace :posting do
    resources :avatars,  :only => [] { get :comments, :on => :member }
    resources :personas, :only => [] { get :comments, :on => :member }
  end

  scope :module => :posting do
    resources :postings, :only => [ :show, :edit, :update ] do |posting|
      resources :comments, :only => [ :index, :new, :create ]

      with_options :controller => 'postings' do |controller|
        controller.delete :unpublish, :on => :member
        controller.get    :fetch,     :on => :collection
      end
    end
  end

  # Personages and Headshots
  resources :profiles, :only => [ :show, :new, :create, :edit, :update ],
      :controller => 'personages' do
    post :avatar, :on => :new
    get  :online, :on => :collection
    member do
      post :avatar
      put  :enable
      put  :switch
      get  :biometrics
      get  :map
      get  :conversation
      get  :invitations
      get  :photos
    end

    resources :friendships, :only => [ :create ], :controller => 'friendships' do
      collection do
        get ':type', :action => 'index', :as => 'typed'
        get ':type/inverse', :action => 'index', :as => 'inverse_typed'
      end
    end

    namespace :wave do
      resource :photos, :only => [ :show ]
    end
  end

  resource :profile, :only => [ :show ],
      :controller => 'personages',
      :as => 'current_personage'

  get ':persona_type' => 'personages#index',
      :constraints => { :persona_type => /ambassadors|communities|places|conditions/ },
      :as => 'persona_type_profiles'

  resource :user, :only => [ :destroy ], :as => 'current_user_record'

  # Geocode
  # resources :locations, :only => [] do
  #   get 'geocode', :on => :collection
  # end

  # Welcome
  namespace :welcome do
    get  'headshot/:pane', :action => 'headshot', :as => 'headshot'
    post 'signup'
    post 'login'
    get  '(/:invitation_code)', :action => 'show'
  end

  post 'launch' => 'welcome#launch'
  match 'logout' => 'user_sessions#destroy', :via => [ :get, :delete ]

  # Reset passwords
  resources :passwords, :only => [ :new, :create, :edit, :update ]

  resources :user_sessions, :only => [ :destroy ] do
    get 'lurk', :on => :new
  end

  # Admin
  namespace :admin do
    # resources :tags, :except => [ :show ] do
    #   collection { get 'commit' }
    # end
    resources :sites, :except => [ :show, :destroy ] do
      resources :users, :only => [ :index, :show, :update ]
      namespace :invitation do
        resources :sites, :except => [ :destroy ]
      end
    end
  end

end
