Rails.application.routes.draw do
  root to: 'pages#home'

  get '/chapters/:id', to: 'pages#chapter', as: 'chapter'
end
