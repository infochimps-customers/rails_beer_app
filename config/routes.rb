BeerApp::Application.routes.draw do

  get "/homepage/v1" => "application#homepage_v1"
  get "/homepage/v2" => "application#homepage_v2"
  get "/homepage/v3" => "application#homepage_v3"
  get "/homepage/v4" => "application#homepage_v4"

  root :to => 'application#about'
  
  resources :beers do
    resource :order, :only => [:create]
  end

  get '/admin' => 'admin#index'

  get '/about' => 'application#about'
  
end
