require 'rubygems'
require 'twitter'
require 'pry'
require 'set'

load 'auth_module.rb' # GET THIS FROM TOMEK

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
      puts mention.text
      puts mention.user.screen_name

      mention_cache << [mention.text, mention.user.screen_name]
    end
  end
  
  sleep(5)
end
