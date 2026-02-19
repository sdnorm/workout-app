Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  root "workouts#index"

  resources :workouts do
    member do
      post :generate
      post :regenerate
      post :complete
    end
    resources :workout_exercises, only: [ :update, :destroy ] do
      post :swap, on: :member
      resources :exercise_sets, only: [ :create, :update, :destroy ]
    end
  end

  resources :runs
  resources :mobility_routines do
    member do
      post :generate
      post :regenerate
      post :complete
    end
  end
  resources :mesocycles do
    member do
      post :start_deload
      post :complete
    end
  end

  resource :profile, only: [ :show, :edit, :update ]
  resource :preferences, only: [ :show, :edit, :update ]
  resources :training_methodologies do
    member do
      post :activate
    end
  end

  # Health check for deployment
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
