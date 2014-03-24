Dolphin::Application.routes.draw do
  root 'home#index'

  get "auth/:provider/callback" => 'sessions#callback'
  get "logout" => 'sessions#logout'
end
