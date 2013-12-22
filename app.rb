require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  erb :login, :layout => :index 
end

get '/login' do 
  erb :login, :layout => :index
end
