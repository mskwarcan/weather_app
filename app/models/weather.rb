class Weather
  include ActiveModel::AttributeAssignment

  attr_accessor :condition, :icon, :current_temp_f, :current_temp_c, :high_f, :high_c, :low_f, :low_c, :date

  def self.format_current_weather(weather:)
    Weather.new.assign_attributes(
      condition: weather["condition"]["text"],
      icon: weather["condition"]["icon"],
      current_temp_f: weather["temp_f"],
      current_temp_c: weather["temp_c"]
    )
  end

  def self.format_forcast_data(weather:)
    Weather.new.assign_attributes(
      date: weather["date"],
      condition: weather["day"]["condition"]["text"],
      icon: weather["day"]["condition"]["icon"],
      high_f: weather["day"]["maxtemp_f"],
      high_c: weather["day"]["maxtemp_c"],
      low_f: weather["day"]["mintemp_f"],
      low_c: weather["day"]["mintemp_c"]
    )
  end
end
