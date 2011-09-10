class ApplicationController < ActionController::Base

  protect_from_forgery

  # Version 1 of the homepage features a default beer.
  def homepage_v1
    @featured_beer = Beer.default_beer
    render :homepage
  end

  # Version 2 of the homepage features a beer based on the visitor's
  # geolocation as determined from their IP address by querying
  # Infochimps' API.
  def homepage_v2
    find_featured_beer_from_geolocation
    render :homepage
  end

  # Version 3 of the homepage additionally tries to determine whether
  # a discount should be applied to the featured beer as determined by
  # the influence of the current Twitter user.
  def homepage_v3
    find_featured_beer_from_geolocation
    determine_discount_from_twitter_influence
    render :homepage
  end

  # Version 4 of the homepage additionally displays a map of stores
  # nearby to the user's location that sell beer.
  def homepage_v4
    find_featured_beer_from_geolocation
    determine_discount_from_twitter_influence
    find_nearby_bars
    render :homepage
  end

  def about
  end

  protected

  # Make an Infochimps API request to the given path with the given
  # query params.
  #
  # Will return a Hash of results or {} if the request fails somehow.
  def infochimps_api_request path, query_params
    require 'net/http'
    all_params = query_params.merge(:apikey => 'demo_apps-3RSa-boH1d5lb9awYqyWLgH3A69')
    query_string = [].tap do |qs|
      all_params.each_pair do |key, value|
        qs << [CGI::escape(key.to_s), CGI::escape(value.to_s)].join('=')
      end
    end.join("&")
    full_path = [path, query_string].join('?')
    result = Net::HTTP.start("api.infochimps.com") do |http|
      http.get(full_path)
    end
    @api_responses                 ||= {}
    @api_responses[full_path]        = {}
    @api_responses[full_path][:code] = result.code
    @api_responses[full_path][:body] = JSON.parse(result.body)
  end

  # Decide what beer to feature by matching the "city" corresponding
  # to the visitor's IP address against the metro_name of our beers.
  def find_featured_beer_from_geolocation
    geolocation    = infochimps_api_request("/web/analytics/ip_mapping/digital_element/geo", :ip => effective_ip)
    @latitude      = geolocation['latitude']
    @longitude     = geolocation['longitude']
    city           = (geolocation["city"] or return Beer.default_beer)
    @featured_beer = (Beer.where("metro_name LIKE ?", city).first || Beer.default_beer)
  end

  # Determine whether to apply a discount based on the current user's
  # Twitter influence.
  def determine_discount_from_twitter_influence
    influence = infochimps_api_request("/social/network/tw/influence/trstrank", :screen_name => effective_twitter_screen_name)
    case 
    when influence['trstrank'].to_f > 4.0
      @discount = :free
    when influence['trstrank'].to_f > 1.0
      @discount = :half
    else
      @discount = nil
    end
  end

  # Uses the visitor's current location (as measured from the IP) to
  # find stores that sell beer nearby.
  def find_nearby_bars
    return unless @latitude.present? && @longitude.present?
    nearby_bars = infochimps_api_request("/geo/location/foursquare/places/search", "f._type" => "business.bar_or_pub", "g.latitude" => @latitude, "g.longitude" => @longitude, "g.radius" => 5000)
    @nearby_bars = nearby_bars['results'] || []
  end

  # For demonstration purposes we want to be able to pretend as though
  # we're visiting from a different IP address than we really are...
  def effective_ip
    @ip = (params[:ip] || request.ip)
  end

  # Instead of dealing with the whole mess of OAuth, for demonstration
  # purposes we fake the current user's Twitter identity from a URL
  # param.
  def effective_twitter_screen_name
    @twitter = params[:twitter]
  end
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      (username == 'rex_banner') && (password == 'beer_baron')
    end
  end
  
end

