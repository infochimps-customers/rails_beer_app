Shopping::Application.routes.draw do

  root :to => "application#homepage"
  
  resources :beers do
    resource :order, :only => [:create]
  end
  
end
