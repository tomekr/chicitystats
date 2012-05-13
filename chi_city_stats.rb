require 'rubygems'
require 'twitter'
require 'pry'
require 'set'
require 'geokit'

load 'auth_module.rb' # GET THIS FROM TOMEK

def respond_to_mention(user, text, location)
  if location
    crime_rating = get_crime_rating user.location
    Twitter.update("@#{ user } #{ crime_rating }")
  else
    Twitter.update("@#{ user } please enable and attatch location to tweet")
  end
end

def get_crime_rating(rectangular_radius)

end

Twitter.configure do |config|
  config.consumer_key       = AuthModule::CONSUMER_KEY
  config.consumer_secret    = AuthModule::CONSUMER_SECRET
  config.oauth_token        = AuthModule::OAUTH_TOKEN
  config.oauth_token_secret = AuthModule::OAUTH_TOKEN_SECRET
end

mention_cache = Set.new

loop do
  mentions = Twitter.mentions
  mentions.each do |mention|
    unless mention_cache.include? [mention.text, mention.user.screen_name]
      location =  mention.place.bounding_box.coordinates if mention.place
      respond_to_mention mention.text, mention.user.screen_name, location
      mention_cache << [mention.text, mention.user.screen_name]
    end
  end
  
  sleep(5)
end


