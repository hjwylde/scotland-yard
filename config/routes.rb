Rails.application.routes.draw do
  root 'games#index'

  resource :user, only: :show
  resource :session, only: [:new, :create, :destroy]

  resources :games, only: [:index, :show, :new, :create] do
    resources :rounds, only: :create
    get '/rounds/current', to: 'rounds#current'

    resources :players, only: [:index, :create] do
      resources :moves, only: :create
    end
    get '/players/active', to: 'players#active'
  end

  resources :nodes, only: :index
  resources :routes, only: :index
end

