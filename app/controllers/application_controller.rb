class ApplicationController < ActionController::Base
  protect_from_forgery

  def homepage
    @featured_beer = Beer.first
  end
  
  
end
