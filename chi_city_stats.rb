require 'rubygems'
require 'twitter'
require 'pry'
require 'set'
require 'json'

load 'auth_module.rb' # GET THIS FROM TOMEK

def respond_to_mention(text, user, location)
  if location
    crime_count, status = get_crime_rating location
    Twitter.update("@#{ user } Thefts: #{ crime_count } Status: #{ status }")
  else
    Twitter.update("@#{ user } please enable and attatch location to tweet")
  end
end

BikeCrimesJSON = JSON.parse(File.read('data/bike_crimes.json'))

# count < 10 = safe
# 10 < count < 50 = low risk
# 50 < count < 100 = medium risk
# 100 < count = high risk

def get_crime_rating(location)
  count = 0
  BikeCrimesJSON["data"].each do |crime|
    if crime[24] and crime[23] and location[:lng] and location[:lat]
      distance = (crime[24].to_f - location[:lng])**2 + (crime[23].to_f - location[:lat])**2
      count += 1 if Math.sqrt(distance) < 0.05
    end

  end
  [count,count > 100 ? "High risk" : count > 50 ? "Medium risk" : count > 10 ? "Low risk" : "Safe"]
end

Twitter.configure do |config|
  config.consumer_key       = AuthModule::CONSUMER_KEY
  config.consumer_secret    = AuthModule::CONSUMER_SECRET
  config.oauth_token        = AuthModule::OAUTH_TOKEN
  config.oauth_token_secret = AuthModule::OAUTH_TOKEN_SECRET
end

mention_cache = Set.new

loop do
  mentions = Array(Twitter.mentions.select! {|m|  m.geo }.first)

  mentions.each do |mention|
    unless mention_cache.include? [mention.text, mention.user.screen_name]
      lat, long  =  mention.geo.coordinates if mention.geo
      puts "lat/long"
      puts lat
      puts long
      coords = {:lat => lat.to_f, :lng => long.to_f}
      respond_to_mention mention.text, mention.user.screen_name, coords
      mention_cache << [mention.text, mention.user.screen_name]
    end
  end
  
  sleep(5)
end
