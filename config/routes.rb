Rails.application.routes.draw do
  root to: 'currency#index'

  mount ActionCable.server => '/cable'
end
