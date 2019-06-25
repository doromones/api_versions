Rails.application.routes.draw do
  get 'main/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'main#index'

  scope 'v(:api_version)', api_version: /[\d\.]+/ do
    get 'main/index'
  end
end
