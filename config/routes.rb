# frozen_string_literal: true
#
Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :reservations, only: [:create]
      put 'reservations', :to => 'reservations#update'
    end
  end
end
