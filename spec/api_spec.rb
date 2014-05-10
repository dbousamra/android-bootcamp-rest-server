require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'API' do
  describe "Treasures routes" do

    before :each do
      @t1 = Treasure.create!(url: "public/images/yow.jpg", coordinates: [151.209055, -33.863016])
      @t2 = Treasure.create!(url: "public/images/yow.jpg", coordinates: [151.209055, -33.863016])
    end

    describe "/treasures" do
      it "returns JSON representing all treasures" do
        get '/treasures'
          last_response.body.should == [@t1, @t2].to_json
      end
    end

    describe "/treasures/:id" do
      it "returns JSON representing the treasure with id :id" do
        get "/treasures/#{@t1.id}"
          last_response.body.should == @t1.to_json
      end
    end    

    describe "/treasures/random/:count" do
      it "returns JSON with a length of :count" do
        get '/treasures/random/1'
          JSON.parse(last_response.body).length.should == 1
      end
    end
  end

  describe "Player routes" do

    before :each do
      @p1 = Player.create!(name: "Dominic Bou-Samra", game_version: 1)
      @p2 = Player.create!(name: "Mary-Anne Cosgrove", game_version: 2)
    end

    describe "/players" do
      it "returns JSON representing all players" do
        get '/players'
          last_response.body.should == [@p1, @p2].to_json
      end

      it "accepts JSON representing a new player and creates a new player, returning the created player with ID" do
          player_to_create = { name: "Dom", game_version: 1 }.to_json
          post "/players",  player_to_create
            created_player = Player.where(name: "Dom").first
            last_response.body.should == created_player.to_json
      end
    end

    describe "/players/:id" do
      it "returns JSON representing the player with id :id" do
        get "/players/#{@p1.id}"
          last_response.body.should == @p1.to_json
      end
    end

    describe "/players/top/:count" do
      it "returns JSON representing the top :count players" do
        p3 = Player.create!(name: "Top scorer one", game_version: 1, score: 3)
        p4 = Player.create!(name: "Top scorer two", game_version: 1, score: 2)
        get "/players/top/2"
          last_response.body.should == [p3, p4].to_json
      end
    end

    describe "/players/score" do
      it "accepts JSON representing a score and increases the players score" do
        score = { score: 10 }.to_json
          post "/players/#{@p1.id}/score", score
            p1_with_score_increased = Player.find(@p1.id)
            last_response.body.should == p1_with_score_increased.to_json
            p1_with_score_increased.score.should == 10
      end
    end
  end
end