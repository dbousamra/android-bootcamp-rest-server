require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'API' do
  describe "/treasures" do

    before :each do
      @t1 = Treasure.create!(url: "public/images/yow.jpg", coordinates: [151.209055, -33.863016])
      @t2 = Treasure.create!(url: "public/images/yow.jpg", coordinates: [151.209055, -33.863016])
    end

    it "returns JSON representing all treasures" do
      get '/treasures'
        last_response.body.should == [@t1, @t2].to_json
    end
  end

  describe "/treasures/random/:count" do

    # it "returns JSON with a length of :count" do
    #   get '/treasures/1'
    #     last_response.body.length.should == 1
    # end

  end

  describe "/treasures/near/" do

  end
end