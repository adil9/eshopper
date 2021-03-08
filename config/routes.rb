Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  devise_for :users, path: 'auth', controllers: {
    passwords: 'auth/passwords',
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }
  namespace :api do
    namespace :v1 do
      resources :shops, only: %i[show index] do
        member do
          post :rate
        end
      end
      resources :items, only: %i[show index]
      resources :carts do
        collection do
          post :update_item
          get :list_item
          post :checkout, to: 'orders#checkout'
        end
      end
      resources :orders, only: %i[show index update]
      post 'update_location', to: 'sessions#update_location'
      get 'logged_in_user', to: 'sessions#logged_in_user'
    end
  end
end
