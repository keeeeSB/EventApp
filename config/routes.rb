Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }
  devise_for :users

  namespace :admins do
    root 'static_pages#dashboard'
    resources :categories, only: %i[index show new edit create update destroy]
  end

  namespace :users do
    resources :events, only: %i[new edit create update destroy]
  end

  resources :events, only: %i[show] do
    collection do
      get :upcoming
      get :past
    end
  end

  root 'static_pages#home'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
