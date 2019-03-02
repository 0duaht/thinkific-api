Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[create] do
        collection do
          get :current
          get :next
          put :update
        end
      end
    end
  end
end
