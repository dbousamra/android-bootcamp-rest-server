require 'spec_helper'

describe 'The Treasure model' do
  
  it "should create a new treasure, and be returned by id" do
    treasure = Treasure.create!(name: "Booty")
    Treasure.where(:id => treasure.id).first.name.should == "Booty"
  end

end