Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    concern :paginatable do
      get "(page/:page)", action: :index, on: :collection, as: ""
    end
    get "/login", to: "auths#new"
    post "/login", to: "auths#create"
    delete "/logout", to: "auths#destroy"
    root to: "static_pages#home"
    get "static_pages/help"
    resources :users, concerns: :paginatable
    resources :account_activations, only: :edit
  end
end
