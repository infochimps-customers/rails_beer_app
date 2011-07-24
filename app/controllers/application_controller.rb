class ApplicationController < ActionController::Base

  INFOCHIMPS_APIKEY = "api_test-W1cipwpcdu9Cbd9pmm8D4Cjc469"
  
  protect_from_forgery

  def homepage_v1
    @featured_beer = default_beer
    render :homepage
  end

  def homepage_v2
    @featured_beer = featured_beer_from_ip
    render :homepage
  end

  def homepage_v3
    @featured_beer = featured_beer_from_ip
    determine_discount
    render :homepage
  end

  protected

  # For demonstration purposes we want to be able to pretend as though
  # we're visiting from a different IP address than we really are...
  def effective_ip
    params[:ip] || request.ip
  end

  # Instead of dealing with the whole mess of OAuth, for demonstration
  # purposes we fake the current user's Twitter identity from a URL
  # param.
  def effective_twitter_screen_name
    @twitter = params[:twitter]
  end

  # Make an Infochimps API request to the given path with the given
  # query params.
  #
  # Will return a Hash of results or {} if the request fails somehow.
  def infochimps_api_request path, query
    require 'net/http'
    all_params = query.merge(:apikey => INFOCHIMPS_APIKEY)
    query_string = [].tap do |qs|
      all_params.each_pair do |key, value|
        qs << [CGI::escape(key.to_s), CGI::escape(value.to_s)].join('=')
      end
    end.join("&")
    full_path = [path, query_string].join('?')
    Rails.logger.debug("GET #{full_path}")
    result = Net::HTTP.start("api.infochimps.com") do |http|
      http.get(full_path)
    end
    @api_responses                 ||= {}
    @api_responses[full_path]        = {}
    @api_responses[full_path][:code] = result.code
    @api_responses[full_path][:body] = JSON.parse(result.body)
  end

  # The beer we should feature if we can't think of a better one
  # dynamically.
  def default_beer
    Beer.first
  end
  
  # Decide what beer to feature based on the demographics of the
  # effective IP address of the request.
  def featured_beer_from_ip
    geolocation = infochimps_api_request("/web/analytics/ip_mapping/digital_element/geo", :ip => effective_ip)
    city        = (geolocation["city"] or return default_beer)
    Beer.where("metro_name LIKE ?", city).first || default_beer
  end

  def determine_discount
    influence = infochimps_api_request("/social/network/tw/influence/trstrank", :screen_name => effective_twitter_screen_name)
    p influence
    case 
    when influence['trstrank'].to_f > 4.0
      @discount = :free
      p 'free'
    when influence['trstrank'].to_f > 1.0
      @discount = :half
      p 'half'
    else
      @discount = nil
    end
  end
end
