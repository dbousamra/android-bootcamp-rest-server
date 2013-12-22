require "sinatra"
require 'json'
require "sinatra/reloader" if development?

before do
  content_type :json
end

get '/' do
  { :key1 => 'value1', :key2 => 'value2' }.to_json
end