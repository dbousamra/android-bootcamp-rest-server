require 'sinatra'
require 'json'
require 'sinatra/reloader' if development?
require 'mongo_mapper'
require 'haml'

configure :production do
  MongoMapper.setup({'production' => {'uri' => ENV['MONGOLAB_URI']}}, 'production')
  MongoMapper.database = URI.parse(ENV['MONGOLAB_URI']).path.gsub(/^\//, '')
end

configure :development, :test do
  MongoMapper.database = 'treasures'
end

set :public_folder, 'public'

get '/' do
  @treasures = Treasure.all
  @players = Player.all
  haml :index
end

get '/players' do
  content_type :json
  Player.all.to_json
end

post '/players' do 
  content_type :json
  data = JSON.parse request.body.read
  p = Player.new(name: data["name"], game_version: data["game_version"])
  p.score = data["score"] if data["score"]
  p.save!
  p.to_json
end

get '/players/:id' do |id|
  content_type :json
  Player.find(id).to_json
end

get '/players/top/:count' do |count|
  content_type :json
  Player.sort(:score.desc).limit(count.to_i).to_json
end

post '/players/:id/score' do |id|
  content_type :json
  data = JSON.parse request.body.read
  p = Player.find(id)
  p.score = data["score"] if data["score"]
  p.save!
  p.to_json
end

get '/treasures' do
  content_type :json
  Treasure.all.to_json
end

get '/treasures/:id' do |id|
  content_type :json
  Treasure.find(id).to_json
end

get '/treasures/random/:count' do |count|
  content_type :json
  Treasure.all.sample(count.to_i).to_json
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