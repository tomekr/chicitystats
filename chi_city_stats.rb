require 'rubygems'
require 'twitter'
require 'pry'
require 'set'
require 'geokit'

load 'auth_module.rb' # GET THIS FROM TOMEK

def respond_to_mention(user, location)
  crime_rating = get_crime_rating user.location
  Twitter.update("@#{ user } #{ crime_rating }")

end

def get_crime_rating(location)

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
      respond_to_mention mention.text, mention.user.screen_name
      mention_cache << [mention.text, mention.user.screen_name]
    end
  end
  
  sleep(5)
end


