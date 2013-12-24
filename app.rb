require 'sinatra'
require 'json'
require 'sinatra/reloader' if development?
require 'mongo_mapper'
require 'haml'

MongoMapper.database = 'treasures'
set :public_folder, 'public'

get '/' do
  @treasures = Treasure.all
  @players = Player.all
  haml :index
end

get '/treasures' do
  content_type :json
  Treasure.all.to_json
end

get '/treasures/random/:count' do |count|
  content_type :json
  Treasure.all.sample(count).to_json
end

get '/treasures/near' do
  content_type :json
  latitude = params[:latitude]
  longitude = params[:longitude]
  distance = params[:distance] || 10
  if !latitude.nil? && !longitude.nil?
    Treasure.near([longitude, latitude], distance, units: :km).to_json
  else 
    Treasure.all.to_json
  end
end

class Player
  include MongoMapper::Document

  key :name,         String,  required: true
  key :score,        Integer, numeric:  true, default: 0
  key :game_version, Integer, required: true

  validate :positive

  private
  def positive
    errors.add(:score, "Score must be 0 or greater") if score < 0
  end
end


class Treasure
  require 'exifr'
  require 'geocoder'
  include MongoMapper::Document
  include Geocoder::Model::MongoMapper

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