Rails.application.routes.draw do
  root to: 'currency#index'
  get 'admin', to: 'currency#new'
  post 'admin', to: 'currency#create'

  mount ActionCable.server => '/cable'
end
