Rails.application.routes.draw do
  devise_for :users,path: 'api/v1/users', controllers: {
    :registrations      => 'api/v1/users/registrations',
    :sessions           => 'api/v1/users/sessions',
  }
  namespace :api do
    namespace :v1 do
      namespace :users do
        put "profiles/update_profile" => "profiles#update_profile"
        post "profiles/google_sign_in" => "profiles#google_sign_in"
        post "passwords/reset"
        post "passwords/forget"
      end
      resources :songs, only: [:index, :show] do
        member do
          put 'like' => "songs#upvote"
          put 'unlike' => "songs#downvote"
        end
        collection do
          get 'liked_songs'
        end
      end
      resources :playlists do
        member do
          put 'update_status'
          delete 'remove_song'
        end
        collection do
          post 'upload_song'
        end
      end
    end
  end
  devise_for :admins, :skip => [:registrations]
  as :admin do
    get "admins/edit" => "devise/registrations#edit", :as => "edit_admin_registration"
    put "admins" => "devise/registrations#update", :as => "admin_registration"
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  namespace :admin do
    resources :admins
  end
  resources :songs do
    member do
      get 'songplay'
    end
  end
  resources :playlists do
    member do
      put 'update_status'
      get 'upload_song'
      delete 'remove_song'
      get 'play'
    end
  end
  root "dashboard#index"
end
