require 'rails_helper'

RSpec.describe Location, type: :model do
  let(:location) { Location.new }

  describe '#retrieve_weather_forecast' do
    let(:retrieve_weather_forecast_method) { location.retrieve_weather_forecast(query: query) }
    let(:query) { 'Austin' }
    let(:api_key) { 'asaosdaslksajfasld' }
    let(:days) { 5 }
    let(:url) { "#{api_url}?key=#{ENV['WEATHER_API']}&q=#{query}&days=#{days}&aqi=no&alerts=no" }
    let(:api_url) { 'https://api.weatherapi.com/v1/forecast.json' }
    let(:weather_api_response) do
      {
        'location' => location_api_data,
        'current' => current_api_data,
        'forecast' => forecast_api_data
      }
    end
    let(:location_api_data) { double(:location_api_data) }
    let(:current_api_data) { double(:current_api_data) }
    let(:forecast_api_data) do
      {
        'forecastday' => [
          forecast_data1,
          forecast_data2
        ]
      }
    end
    let(:forecast_data1) { double(:forecast_data1) }
    let(:forecast_data2) { double(:forecast_data2) }
    let(:formatted_forecast1) { double(:formatted_forecast1) }
    let(:formatted_forecast2) { double(:formatted_forecast2) }
    let(:formatted_location_data) { double(:formatted_location_data) }
    let(:formatted_current_weather) { double(:formatted_current_weather) }

    before do
      ENV['WEATHER_API'] = api_key

      expect(location).to receive(:make_api_request).with(url: url).and_return(weather_api_response)
      expect(location).to receive(:format_location_data).with(location: location_api_data).and_return(formatted_location_data)
      expect(Weather).to receive(:format_current_weather).with(weather: current_api_data).and_return(formatted_current_weather)
      expect(Weather).to receive(:format_forcast_data).with(weather: forecast_data1).and_return(formatted_forecast1)
      expect(Weather).to receive(:format_forcast_data).with(weather: forecast_data2).and_return(formatted_forecast2)
    end

    it 'should return a hash of compiled data' do
      expect(retrieve_weather_forecast_method).to eq(
        {
          location: formatted_location_data,
          current_weather: formatted_current_weather,
          forecast_data: [
            formatted_forecast1,
            formatted_forecast2
          ]
        }
      )
    end
  end

  describe '#format_location_data' do
    let(:location_input) do
      {
        'name' => name,
        'region' => 'Texas',
        'country' => country,
        'lat' => lat,
        'lon' => lon,
        'tz_id' => 'America/Chicago',
        'localtime_epoch' => 1730497122,
        'localtime' => '2024-11-01 16 =>38'
      }
    end
    let(:location_output) do
       location.assign_attributes(
         {
           name: name,
           country: country,
           postal_code: postal_code,
           city: city,
           state: state
         }
       )
    end
    let(:lat) { 30.2669 }
    let(:lon) { -97.7428 }
    let(:name) { 'Austin' }
    let(:country) { 'United States' }
    let(:postal_code) { '78701' }
    let(:city) { 'Austin' }
    let(:state) { 'Texas' }
    let(:format_location_data_method) { location.format_location_data(location: location_input) }
    let(:geocode_data) do
      [
        double(
          :geodata,
          postal_code: postal_code,
          city: city,
          state: state
        )
      ]
    end

    before do
      expect(Geocoder).to receive(:search).with([ lat, lon ]).and_return(geocode_data)
    end

    it 'should return location with assigned attributes' do
      expect(format_location_data_method).to eq(location_output)
    end
  end

  describe '#make_api_request' do
    let(:url) { 'https://test.com' }
    let(:make_api_request_method) { location.make_api_request(url: url) }
    let(:http_method) { :get }
    let(:valid_response) { true }
    let(:response_body) do
      {
        'Success': { 'TransactionId' => '123456789' }
      }.to_json
    end
    let(:status) { 200 }
    let(:response) do
       Struct.new(:code, :parsed_response, :ok?).new(status, response_body, valid_response)
    end

    context 'HTTParty throws an error' do
      let(:error) { 'Timeout exceeded' }
      it 'should raise the error message' do
        expect(HTTParty).to receive(:send).with(http_method, url).and_raise(error)
        expect { make_api_request_method }.to raise_error(error)
      end
    end

    context 'http response is not a 200' do
      let(:valid_response) { false }
      let(:status) { 400 }
      let(:response_body) do
        {
          'error' => {
            'message' => error_message
          }
        }
      end
      let(:error_message) { 'Invalid request' }

      it 'should raise the error message' do
        expect(HTTParty).to receive(:send).with(http_method, url).and_return(response)
        expect { make_api_request_method }.to raise_error(error_message)
      end
    end

    context 'http response is a 200' do
      before do
        expect(HTTParty).to receive(:send).with(http_method, url).and_return(response)
      end

      context 'http method is passed in' do
        let(:make_api_request_method) { location.make_api_request(url: url, http_method: http_method) }
        let(:http_method) { :post }

        it 'should return the response' do
          expect(make_api_request_method).to eq(response)
        end
      end

      context 'http method is not passed in' do
        it 'should return the response' do
          expect(make_api_request_method).to eq(response)
        end
      end
    end
  end
end
