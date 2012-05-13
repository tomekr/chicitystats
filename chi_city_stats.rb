require 'rubygems'
require 'twitter'

load 'auth_module.rb' # GET THIS FROM TOMEK

puts AuthModule::CONSUMER_SECRET

Twitter.configure do |config|
  config.consumer_key       = AuthModule::CONSUMER_KEY
  config.consumer_secret    = AuthModule::CONSUMER_SECRET
  config.oauth_token        = AuthModule::OAUTH_TOKEN
  config.oauth_token_secret = AuthModule::OAUTH_TOKEN_SECRET
end

puts Twitter.home_timeline.first.text
