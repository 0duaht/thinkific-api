Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create update] do
        collection do
          get :current
          get :next
        end
      end
    end
  end
end
