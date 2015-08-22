Rails.application.routes.draw do
  root 'home#index'
  #root :to => redirect('/no-borders')

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  resources :tournaments, path: '', except: [:show] do
    namespace :admin do
      get "/" => "tournaments#show"

      resources :fields

      resources :teams do
        collection do
          post :import
        end
      end

      resources :brackets do
        member do
          put :seed
        end
        collection do
          put :update_seeds
        end
      end

      get '/schedule', to: 'schedule#index'
      post '/schedule', to: 'schedule#update'

      resources :games
    end
  end
  get '*tournament_id' => 'app#show'
  post '*tournament_id/submit_score' => 'app#score_submit', as: 'app_score_submit'
end
