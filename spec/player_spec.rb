require 'spec_helper'

describe 'The Player model' do
  describe "name" do
    it "should have a name" do
      player = Player.create!(name: "Dominic Bou-Samra", game_version: 1)
      player.name.should == "Dominic Bou-Samra"
    end

    it "should be invalid without a name" do
      player = Player.new(game_version: 1)
      player.should_not be_valid
    end
  end

  describe 'score' do
    it "should have a default score of 0" do
      player = Player.create!(name: "Dominic Bou-Samra", game_version: 1)
      player.score.should == 0
    end

    it "should be able to set a score" do
      player = Player.create!(name: "Dominic Bou-Samra", score: 10, game_version: 1)
      player.score.should == 10
    end

    it "should not be valid with a negative score" do
      player = Player.new(name: "Dominic Bou-Samra", score: -1, game_version: 1)
      player.should_not be_valid
    end 
  end

  describe "game version" do
    it "should be able to set a game version" do
      player = Player.create!(name: "Dominic Bou-Samra", game_version: 1)
      player.game_version.should == 1
    end

    it "should not be valid without a game_version" do
      player = Player.new(name: "Dominic Bou-Samra")
      player.should_not be_valid
    end 
  end

end