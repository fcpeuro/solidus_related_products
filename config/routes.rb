# frozen_string_literal: true

Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :relation_types, except: :show
    resources :products, only: [] do
      get :related, on: :member
      resources :relations, except: :show do
        collection do
          post :update_positions
        end
      end
      resources :variants, only: [] do
        resources :relations, module: 'variants', except: :show do
          collection do
            post :update_positions
          end
        end
      end
    end
  end

  namespace :api, defaults: { format: 'json' } do
    resources :products, only: [] do
      resources :relations, only: [:index, :show, :create, :update, :destroy] do
        collection do
          post :update_positions
        end
      end
      resources :variants, only: [] do
        resources :relations, module: 'variants', only: [:index, :show, :create, :update, :destroy] do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end
