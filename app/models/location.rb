class Location
  include ActiveModel::AttributeAssignment

  attr_accessor :name, :country, :postal_code, :city, :state

  API_URL = "https://api.weatherapi.com/v1/forecast.json"

  def retrieve_weather_forecast(query:, days: 5)
    forecast_url = "#{API_URL}?key=#{ENV['WEATHER_API']}&q=#{query}&days=#{days}&aqi=no&alerts=no"
    response = make_api_request(url: forecast_url)

    location = format_location_data(location: response["location"])
    current_weather = Weather.format_current_weather(weather: response["current"])
    forecast_data = response["forecast"]["forecastday"].collect { |weather| Weather.format_forcast_data(weather: weather) }

    {
      location: location,
      current_weather: current_weather,
      forecast_data: forecast_data
    }
  end

  def format_location_data(location:)
    # This is needed because the API only returns the Lat/Lon and we need to cache by postal codes
    location_lookup = Geocoder.search([ location["lat"], location["lon"] ])
    location_data = location_lookup.first

    self.assign_attributes(
      name: location["name"],
      country: location["country"],
      postal_code: location_data.postal_code,
      city: location_data.city,
      state: location_data.state
    )
  end

  def make_api_request(url:, http_method: :get)
    begin
      response = HTTParty.send(http_method, url)
    rescue => e
      raise e.message
    end

    raise response.parsed_response["error"]["message"] if !response.ok?
    response
  end
end
