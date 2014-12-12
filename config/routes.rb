Rails.application.routes.draw do
  root 'games#index'

  resources :games, only: [:index, :show, :new, :create] do
    resources :rounds, only: [:create]
    get '/rounds/current', to: 'rounds#current', as: 'rounds_current'

    resources :players, only: [:index, :create], shallow: true do
      resources :moves, only: [:create]
    end
  end

  resources :nodes, only: [:index]
  resources :routes, only: [:index]
end

