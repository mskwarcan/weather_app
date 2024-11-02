require 'rails_helper'

RSpec.describe Weather, type: :model do
  describe 'Weather#format_current_weather' do
    let(:weather) do
      {
        'condition' => {
          'text' => text,
          'icon' => icon
        },
        'temp_c' => temp_c,
        'temp_f' => temp_f
      }
    end
    let(:text) { 'Cloudy' }
    let(:icon) { '//cdn.weatherapi.com/weather/64x64/day/302.png' }
    let(:temp_c) { 45.2 }
    let(:temp_f) { 71.4 }
    let(:format_current_weather_method) do
      described_class.format_current_weather(weather: weather)
    end

    it 'should assign and return a weather object' do
      expect(format_current_weather_method).to eq(
        described_class.new.assign_attributes(
          condition: text,
          icon: icon,
          current_temp_f: temp_f,
          current_temp_c: temp_c
        )
      )
    end
  end

  describe 'Weather#format_forcast_data' do
    let(:weather) do
      {
        'date' => date,
        'day' => {
          'condition' => {
            'text' => text,
            'icon' => icon
          },
          'maxtemp_c' => maxtemp_c,
          'maxtemp_f' => maxtemp_f,
          'mintemp_c' => mintemp_c,
          'mintemp_f' => mintemp_f
        }
      }
    end
    let(:date) { '2024-10-24' }
    let(:text) { 'Cloudy' }
    let(:icon) { '//cdn.weatherapi.com/weather/64x64/day/302.png' }
    let(:maxtemp_c) { 45.2 }
    let(:maxtemp_f) { 71.4 }
    let(:mintemp_c) { 22.9 }
    let(:mintemp_f) { 54.7 }
    let(:format_forcast_data_method) do
      described_class.format_forcast_data(weather: weather)
    end

    it 'should assign and return a weather object' do
      expect(format_forcast_data_method).to eq(
        described_class.new.assign_attributes(
          date: date,
          condition: text,
          icon: icon,
          high_f: maxtemp_f,
          high_c: maxtemp_c,
          low_f: mintemp_f,
          low_c: mintemp_c
        )
      )
    end
  end
end
