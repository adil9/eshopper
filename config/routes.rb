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
      get 'logged_in_user', to: 'sessions#logged_in_user'
    end
  end

end
