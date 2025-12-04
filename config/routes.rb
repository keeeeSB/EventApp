Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
  }
  devise_for :users

  namespace :admins do
    root 'static_pages#dashboard'
    resources :categories, only: %i[index show new edit create update destroy]
    resources :events, only: %i[index show edit update destroy] do
      resources :reviews, only: %i[index show destroy], module: :events
    end
    resources :users, only: %i[index show edit update destroy]
    resources :reviews, only: %i[index show destroy]
  end

  namespace :users do
    resources :events, only: %i[new edit create update destroy] do
      resources :entries, only: %i[index update], module: :events
    end
    resources :my_events, only: %i[index]
  end

  namespace :events do
    resources :ranking, param: :slug, only: %i[index]
  end

  resources :events, only: %i[show] do
    collection do
      get :upcoming
      get :past
    end
    resource :entry, only: %i[create destroy], module: :events
    resource :review, only: %i[new edit create update destroy], module: :events
  end

  root 'events#upcoming'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'up' => 'rails/health#show', as: :rails_health_check
end
