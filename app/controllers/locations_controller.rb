class LocationsController < ApplicationController
  before_action :check_for_cached_data, :check_api_keys

  def index
    begin
      if params[:query].present?
        @data = Location.new.retrieve_weather_forecast(query: params[:query])
        postal_code = @data[:location][:postal_code]
        Rails.cache.write(postal_code, @data, expires_in: 30.minutes) if postal_code.present?
      end
    rescue => e
      @error = {
        "error": e.message
      }
    end
  end

  def check_for_cached_data
    @data = Rails.cache.fetch(params[:query]) if params[:query].present?
    if @data.present?
      @cached = true
      @data
    end
  end

  def check_api_keys
    if ENV["WEATHER_API"].nil? || ENV["GEOLOCATE_API"].nil?
      @error = {
        "error": "API Keys are not set."
      }
      @error
    end
  end
end
