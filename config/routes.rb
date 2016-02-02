Rails.application.routes.draw do
  resources :best_of_days

  resources :grades_imports do
      member do
          get '/norme_masters', action: 'norme_masters'
      end
  end

  resources :negative_points do
      collection do
          get '/attribution', action: 'attribution'
          post '/attribution_create', action: 'attribution_create'
      end

      member do
          get '/undo_attribution/:attribution_id', action: 'undo_attribution', as: 'undo_attribution'
      end
  end

  resources :positive_points do
      collection do
          get '/attribution', action: 'attribution'
          post '/attribution_create', action: 'attribution_create'
      end

      member do
          get '/undo_attribution/:attribution_id', action: 'undo_attribution', as: 'undo_attribution'
      end
  end

  resources :asteks do
  end

  resources :pedagos do
  end

  resources :students do
  end

  resources :families do
      member do
          get '/bonus_details', action: 'bonus_details'
          get '/import_users', action: 'import_users'
          post '/import_users_create', action: 'import_users_create'
          get '/show_members/:entity', action: 'show_members', as: 'show_members'
      end

      collection do
          get '/score_details', action: 'score_details'
      end
  end

  post 'login_create', controller: 'application', action: 'login_create'
  get 'logout', controller: 'application', action: 'logout'

  root 'families#index'
end
