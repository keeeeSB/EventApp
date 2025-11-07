Rails.application.routes.draw do
  root "static_pages#home"

  get 'up' => 'rails/health#show', as: :rails_health_check
end
