# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :devices, only: [] do
    member do
      post 'readings'
      get 'latest_reading'
      get 'cumulative_count'
    end
  end
end
