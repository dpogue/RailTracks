RailsTunes::Application.routes.draw do
  devise_for :users

  resources :libraries, :only => [:index, :new, :create, :show, :destroy]

  resources :artists, :only => [:index, :show]
  match 'artists/search/:q' => 'artists#search', :via => :get, :as => 'search_artists'

  resources :songs, :only => [:index, :show]
  match 'songs/search/:q' => 'songs#search', :via => :get, :as => 'search_songs'

  root :to => 'railtracks#index'
end
