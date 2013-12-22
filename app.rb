require "sinatra"
require 'json'
require "sinatra/reloader" if development?
require 'mongo_mapper'

MongoMapper.database = 'treasures'

before do
  content_type :json
end

get '/' do
  { :key1 => 'value1', :key2 => 'value2' }.to_json
end

class Treasure
  include MongoMapper::Document
  key :name,        String, required: true
end