Rails.application.routes.draw do
  resources :clients do
    collection do
      get :import
      post :do_import
    end
  end
  resources :projects do
    collection do
      get :import
      post :do_import
    end
  end
  root :to => 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
