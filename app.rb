require 'sinatra'
require 'json'
require 'sinatra/reloader' if development?
require 'mongo_mapper'

MongoMapper.database = 'treasures'

before do
  content_type :json
end

set :public_folder, 'public'

get '/' do
  { :key1 => 'value1', :key2 => 'value2' }.to_json
end

get '/treasures' do
  Treasure.all.to_json
end

class Treasure
  require 'exifr'
  require 'geocoder'
  require 'pry-debugger'
  include MongoMapper::Document
  include Geocoder::Model::MongoMapper

  key :name,        String, required: true
  key :url,         String, required: true
  key :coordinates, Array,  required: true # long, lat (not lat, long)
  key :address,     String
  before_validation   :geolocate
  reverse_geocoded_by :coordinates
  after_validation    :reverse_geocode

  private
  def geolocate
    exif = EXIFR::JPEG.new(self.url)
    self.coordinates = [exif.gps.longitude, exif.gps.latitude] if self.coordinates.empty?
  end
end