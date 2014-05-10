require 'spec_helper'

describe 'The Treasure model' do
  
  it "should have a latitude and longitude" do
    treasure = Treasure.create!(url: "public/images/Treasures1.jpg", coordinates: [151.209055, -33.863016])
    treasure.coordinates.should == [151.209055, -33.863016]
  end

  it "creates a new treasure, and be returned by id" do
    treasure = Treasure.create!(url: "public/images/Treasures1.jpg")
    Treasure.where(id: treasure.id).first.url.should == "public/images/Treasures1.jpg"
  end

  describe "no longitude and latitude set" do
    it "geocodes the image url's location and sets the long/lat" do
      treasure = Treasure.create!(url: "public/images/Treasures1.jpg")
      treasure.coordinates.should ==  [151.21116666666666, -33.8615]
    end

    it "geocodes the image url's location and sets address" do
      treasure = Treasure.create!(url: "public/images/Treasures1.jpg")
      treasure.address.should =~ /Cahill Expressway, Sydney NSW 2000, Australia/
    end
  end

  describe "longitude and latitude set" do
    it "geocodes the long and lat and sets the address" do
      treasure = Treasure.create!(url: "public/images/Treasures1.jpg", coordinates: [151.209055, -33.863016])
      treasure.coordinates.should == [151.209055, -33.863016]
      treasure.address.should =~ /51 Pitt Street/
    end
  end

  it "returns a list of participants" do
    Treasure.create!(url: "public/images/Treasures1.jpg")
    Treasure.create!(url: "public/images/Treasures1.jpg")
    Treasure.count.should == 2
  end
end