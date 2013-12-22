require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe 'Initial Integration Test' do
  it "defaults to login" do
    get '/'
      last_response.body.should include 'username'
      last_response.body.should include 'password'
      last_response.should be_ok
  end
end

describe 'login' do
  it "shows the login page" do
    get '/login'
    last_response.should be_ok
  end
end