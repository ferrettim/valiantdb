require 'sidekiq/web'

Rails.application.routes.draw do

  resources :feeds do
    get "news", :action => :news, as: :news
    member do
     resources :entries, only: [:index, :show]
    end
  end

  resources :feeds
  resources :previews
  resources :activities
  resources :polls
  resources :pollvotes, only: [:create]


  resources :characters do
    get "characters/:page", :action => :index, :on => :collection
    get :autocomplete_character_creator, :on => :collection
    get :autocomplete_character_creator2, :on => :collection
    collection do
      get :all
    end
  end

  resources :collectibles do
    get "collectibles/:page", :action => :index, :on => :collection
    collection do
      get :all
    end
    resource :itemwish, module: :collectibles
    resource :itemown, module: :collectibles
    resource :itemsale, module: :collectibles
  end

  post '/rate' => 'rater#create', :as => 'rate'
  resources :books do
    get "books/:page", :action => :index, :on => :collection
    get :autocomplete_book_title, :on => :collection
    get :autocomplete_book_writer, :on => :collection
    get :autocomplete_book_writer2, :on => :collection
    get :autocomplete_book_artist, :on => :collection
    get :autocomplete_book_artist2, :on => :collection
    get :autocomplete_book_colors, :on => :collection
    get :autocomplete_book_cover, :on => :collection
    get :autocomplete_book_letters, :on => :collection
    get :autocomplete_book_editor, :on => :collection
    get :autocomplete_book_eic, :on => :collection
    get :autocomplete_book_country, :on => :collection
    get :autocomplete_book_publisher, :on => :collection
    get :autocomplete_book_imprint, :on => :collection
    get :autocomplete_book_retailer, :on => :collection
    get :autocomplete_book_convention, :on => :collection
    resources :comments
    collection do
      post :import
      get :autocomplete

      # Valiant
      get "valiant/keys" => "books#valiantkeys"
      get "valiant/all" => "books#valiantall"
      get "valiant/all/table" => "books#valiantalltbl"
      get "valiant/all/missing" => "books#valiantallmissing"
      get "valiant/all/table/missing" => "books#valiantalltblmissing"
      get "valiant/sketch" => "books#valiantsketch"
      get "valiant/sketch/table" => "books#valiantsketchtbl"
      get "valiant/trades" => "books#valianttrades"
      get "valiant/trades/table" => "books#valianttradestbl"

      # VH1 Valiant
      get "valiant/classic/all" => "books#valiantvh1all"
      get "valiant/classic/all/table" => "books#valiantvh1alltbl"
      get "valiant/classic/keys" => "books#valiantvh1keys"
      get "valiant/classic/all/missing" => "books#valiantvh1allmissing"
      get "valiant/classic/all/table/missing" => "books#valiantvh1alltblmissing"

      # VH2 Valiant
      get "valiant/acclaim/all" => "books#valiantvh2all"
      get "valiant/acclaim/all/table" => "books#valiantvh2alltbl"
      get "valiant/acclaim/all/missing" => "books#valiantvh2allmissing"
      get "valiant/acclaim/all/table/missing" => "books#valiantvh2alltblmissing"

      # International Valiant
      get "valiant/brazil/all" => "books#valiantbrazil"
      get "valiant/brazil/table" => "books#valiantbraziltbl"
      get "valiant/brazil/missing" => "books#valiantbrazilmissing"
      get "valiant/brazil/table/missing" => "books#valiantbraziltblmissing"
      get "valiant/canada/all" => "books#valiantcanada"
      get "valiant/canada/table" => "books#valiantcanadatbl"
      get "valiant/canada/missing" => "books#valiantcanadamissing"
      get "valiant/canada/table/missing" => "books#valiantcanadatblmissing"
      get "valiant/china/all" => "books#valiantchina"
      get "valiant/china/table" => "books#valiantchinatbl"
      get "valiant/china/missing" => "books#valiantchinamissing"
      get "valiant/china/table/missing" => "books#valiantchinatblmissing"
      get "valiant/france/all" => "books#valiantfrance"
      get "valiant/france/table" => "books#valiantfrancetbl"
      get "valiant/france/missing" => "books#valiantfrancemissing"
      get "valiant/france/table/missing" => "books#valiantfrancetblmissing"
      get "valiant/italy/all" => "books#valiantitaly"
      get "valiant/italy/table" => "books#valiantitalytbl"
      get "valiant/italy/missing" => "books#valiantitalymissing"
      get "valiant/italy/table/missing" => "books#valiantitalytblmissing"
      get "valiant/japan/all" => "books#valiantjapan"
      get "valiant/japan/table" => "books#valiantjapantbl"
      get "valiant/japan/missing" => "books#valiantjapanmissing"
      get "valiant/japan/table/missing" => "books#valiantjapantblmissing"
      get "valiant/mexico/all" => "books#valiantmexico"
      get "valiant/mexico/table" => "books#valiantmexicotbl"
      get "valiant/mexico/missing" => "books#valiantmexicomissing"
      get "valiant/mexico/table/missing" => "books#valiantmexicotblmissing"
      get "valiant/russia/all" => "books#valiantrussia"
      get "valiant/russia/table" => "books#valiantrussiatbl"
      get "valiant/russia/missing" => "books#valiantrussiamissing"
      get "valiant/russia/table/missing" => "books#valiantrussiatblmissing"
      get "valiant/turkey/all" => "books#valiantturkey"
      get "valiant/turkey/table" => "books#valiantturkeytbl"
      get "valiant/turkey/missing" => "books#valiantturkeymissing"
      get "valiant/turkey/table/missing" => "books#valiantturkeytblmissing"

      # Events Valiant
      get "valiant/events/4001ad" => "books#valiantevent4001ad"
      get "valiant/events/harbingerwars" => "books#valianteventshw"
      get "valiant/events/armorhunters" => "books#valianteventsah"
      get "valiant/events/bookofdeath" => "books#valianteventsbod"
      get "valiant/events/unity" => "books#valianteventsunity"
      get "valiant/events/chaoseffect" => "books#valianteventschaoseffect"
      get :manage
    end
    resource :wish, module: :books
    resource :own, module: :books
    resource :sale, module: :books
  end

  devise_for :users, :controllers => { :registrations => 'registrations', :omniauth_callbacks => 'omniauth_callbacks', sessions: 'sessions' }, :path => "", :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  match '/users/:id' => 'users#destroy', :via => [:delete], :as => :admin_destroy_user
  match '/users/:id/profile' => "users#show", via: [:get], :as => 'profile'
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  match '/users/all' => 'users#all', via: [:get]
  match '/users/backers' => 'users#backers', via: [:get]
  match '/users/top25' => 'users#valianttop25', via: [:get]
  match '/users/leaderboard' => 'users#leaderboard', via: [:get]
  match '/users/:id/followers' => "users#followers", via: [:get], :as => 'followers'
  match '/users/:id/following' => "users#following", via: [:get], :as => 'following'
  get 'users/:id/notes' => 'books#mynotes', :as => 'notes'
  get 'users/:id/collection' => 'books#mybooks', :as => 'collection'
  get 'users/:id/collection/table' => 'books#mybookstbl', :as => 'collection_table'
  get 'users/:id/wishlist' => 'books#mywishlist', :as => 'wishlist'
  get 'users/:id/wishlist/table' => 'books#mywishlisttbl', :as => 'wishlist_table'
  get 'users/:id/forsale' => 'books#forsale', :as => 'forsale'
  get 'users/:id/forsale/table' => 'books#forsaletbl', :as => 'forsale_table'
  get 'users/emails' => 'users#emails', via: [:get]
  match 'follow' => 'users#follow', via: [:get]
  match 'unfollow' => 'users#unfollow', via: [:get]
  get 'switch_user' => 'switch_user#set_current_user'

  # Releases
  get 'nextweek' => 'books#thisweek'
  get 'releases/thisweek' => 'books#thisweek'
  get 'releases/currentweek' => 'books#currentweek'
  get 'releases/nextweek' => 'books#nextweek'
  get 'releases/solicitations' => 'books#solicitations'
  get 'releases/lastmonth' => 'books#lastmonth'
  get 'releases/thismonth' => 'books#thismonth'
  get 'releases/nextmonth' => 'books#nextmonth'
  get 'releases/twomonths' => 'books#monthafter'
  get 'releases/latestsolicitations' => 'books#latestsolicits'
  get 'releases/veibydate' => 'books#valiantreleasedate'
  get 'releases/veibydate/table' => 'books#valiantreleasedatetbl'
  get 'timelines/valiant' => 'pages#veitimeline'
  get 'releases/vh1bydate' => 'books#valiantvh1releasedate'
  get 'releases/vh1bydate/table' => 'books#valiantvh1releasedatetbl'
  get 'changelog' => 'pages#changelog'
  get 'supportus' => 'pages#supportus'

  # Sales
  get 'sales/monthly' => 'books#monthlysales'
  get 'sales/yearly' => 'books#yearlysales'
  get 'sales/marketshare' => 'pages#marketshare'
  get 'sales/vei' => 'books#valiantsalesvei'
  get 'sales/veibytitle' => 'books#valiantsalestitle'
  get 'sales/statistics' => 'books#valiantsalesstats'
  get 'sales/titlestatistics' => 'books#valiantsalesstatstitle'
  get 'sales/topselling' => 'books#valianttopselling'
  get 'values/topvalues' => 'books#valianttopvalues'
  get 'values/rankings' => 'books#valiantvalues'
  get 'values/missing' => 'books#valiantvaluesmissing'
  get 'feed' => 'books#feed'
  get 'allfeed' => 'books#allfeed'

  resources "contacts", only: [:new, :create]
  get 'privacy' => 'pages#privacy'
  get 'terms' => 'pages#terms'
  get 'search' => 'pages#search'
  get 'userlevels' => 'pages#levels'
  get 'news' => 'feeds#news', as: :news
  get 'chat' => 'pages#chat', as: :chat

  match 'sitemap', :to => 'sitemap#index', :via => [:get]

  # Mailbox routes
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  get "mailbox/trash" => "mailbox#trash", as: :mailbox_trash
  get "empty_trash", to: "conversations#empty_trash"

  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
  end

  root :to => 'pages#home'

  # Require authentication to access Sidekiq dashboard
  authenticate :user, lambda { |u| u.admin? } do
    if Rails.env.production?
      mount Sidekiq::Web, at: '/sidekiq'
    end
    get 'stats' => 'users#admin', :as => 'user_statistics'
  end

  # ERROR HANDLING
  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
  #match '*path', to: 'errors#file_not_found', via: :all
  get 'errors/file_not_found' => "errors#file_not_found"
  get 'errors/unprocessable' => "errors#unprocessable"
  get 'errors/internal_server_error' => "errors#internal_server_error"
end
