# README

## About this App
The goal of the application is to built an app that can accept an address and retrieve the current weather for that address. It also retrieves the current condition, high and lows, and 5 day forecast.

When searching specifically by the postal code, it'll also cache the data for 30 minutes if simply return the data if you search again using the same postal code. There is a UI alert that let's you know when it is returning cached data.

## API Usage
In order to get the weather data we needed, I looked into a handful of free weather APIs and found Weather API (https://www.weatherapi.com) to be the best resource. An API Key is needed in order to access their API, but it's free for the amount of usage we'll have for our application. You do need to set up a free account in order to receive your API Key.

There's a second API I'm also using called Geoapify (https://www.geoapify.com/) to do a reverse lookup on the Lat/Lng provided by the weather API to get additional regional details like city, state, and postal code. I needed to do this so if you searched for an address without a zip code and the searched using specifically the zip code, I could pull the cached data.

## Environment Variables
Since we're using 2 different APIs, we'll want to store 2 environment variables. The easist would be to just export them on your server:
```
GEOLOCATE_API=XXXXXXXXXXXXXXXXXXXXXXXXX
WEATHER_API=XXXXXXXXXXXXXXXXXXXXXXXXXX
```

But if you have another way of managing your environment variables, feel free to do so.

## Gems
This app only uses 2 gems that are not bundled with Rails.
* HTTParty - Not needed but I prefer to use this library for HTTP calls but 
* Geocoder - Makes integrating the Geoapify API into the application a breeze
* Rspec-Rails - Used for test suite

## Versions
This was built using Ruby 3.3.5 and Rails 8.0.0.rc2 but it should be completely compatible with older versions of Ruby or Rails.

## Database
There is no database. They was no need to store anything and we're only doing some small caching around the search.

## How to run the test suite
Since it's a fairly basic app, I've just wrote unit tests for the models. 
```
rspec
```

## Setting up the Application
Once in the the app folder, run:
```
bundle install
```
Make sure you have the 2 environment variables set (shown above).

Then just run:
```
rails server
```
And you should be able to run the app without issue locally.