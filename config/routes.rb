# frozen_string_literal: true

Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/api/docs'
  mount Rswag::Api::Engine => '/api-docs'

  # resources :users
  resources :organizations, only: [:create]
  resources :activities, only: [:create, :update]
  resources :members, only: [:index, :create, :destroy, :update]
  resources :testimonials, only: [:create, :destroy, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'organizations/public', to: 'organizations#index'
  post 'organizations/public/:id', to: 'organizations#update'
  post '/auth/register', to: 'users#create'
  post 'auth/login', to: 'authentication#login'
  post 'contacts', to: 'contacts#create'
  get 'backoffice/contacts', to: 'contacts#allContacts'
  get 'contacts', to: 'contacts#index'
  get    'auth/me', to: 'users#profile'
  get    'users', to: 'users#showUsers'
  get 'news/query', to: 'news#index'
  get 'members/query', to: 'members#index'
  get 'testimonials/query', to: 'testimonials#index'
  patch  '/users/:id', to: 'users#update'
  delete 'users/:id', to: 'users#destroy'
  resources :categories, only: %i[index create show destroy update]
  #resources :members, only: [:index]
  resources :testimonials, only: [:index]

  post 'organizations/social/:id', to: 'organizations#add_social'

  resources :news, only: %i[index show create update destroy] do
    get 'comments'
  end
  resources :comments, only: %i[index create update destroy]
  resources :slides, only: %i[index show create update destroy]
end
