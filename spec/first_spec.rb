require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Initial integration Test' do
  it "returns some json" do
    get '/'
      last_response.body.should include 'value1'
  end
end