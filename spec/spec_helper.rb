require File.dirname(__FILE__) + '/../app'
require 'rspec'
require 'rack/test'
require 'database_cleaner'

set :environment, :test

RSpec.configure do |conf|
  conf.color_enabled = true
  config.tty = true
  conf.include Rack::Test::Methods

  conf.before(:suite) do
    DatabaseCleaner[:mongo_mapper].strategy = :truncation
    DatabaseCleaner[:mongo_mapper].clean_with(:truncation)
  end

  conf.before(:each) do
    DatabaseCleaner[:mongo_mapper].start
  end

  conf.after(:each) do
    DatabaseCleaner[:mongo_mapper].clean
  end
end

def app
  Sinatra::Application
end