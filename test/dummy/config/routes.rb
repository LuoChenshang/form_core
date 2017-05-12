Rails.application.routes.draw do

  resources :categories

  resources :forms do
    scope module: :forms do
      resource :preview, only: [:show, :create]
      resources :sections, except: [:show]
      resources :fields, except: [:show] do
        scope module: :fields do
          resource :validations, only: [:edit, :update]
          resource :options, only: [:edit, :update]
        end
      end
    end
  end

  root to: 'home#index'
end
