Shopping::Application.routes.draw do

  get "/homepage/v1" => "application#homepage_v1"
  get "/homepage/v2" => "application#homepage_v2"
  get "/homepage/v3" => "application#homepage_v3"

  root :to => 'application#homepage_v1'
  
  resources :beers do
    resource :order, :only => [:create]
  end

  get '/admin' => 'admin#index'
  
end
