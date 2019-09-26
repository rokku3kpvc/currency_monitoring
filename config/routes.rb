Rails.application.routes.draw do
  root to: 'currency#index'
  get 'admin', action: :new, controller: 'currency'
  post 'admin', action: :create, controller: 'currency'
  # get 'admin', to: 'currency#new'
  # post 'admin', to: 'currency#create'
  # namespace :currency, only: [] do
  #   get :new, on: :member, path: '/admin'
  # end

  mount ActionCable.server => '/cable'
end
