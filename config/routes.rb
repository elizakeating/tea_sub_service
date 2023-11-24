Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      post "/customers/:customer_id/subscriptions/:subscription_id", to: "subscription_customers#create"
    end
  end
end
