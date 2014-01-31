require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api#user' do

  it 'should get user info' do

    body = '{"userId":"9999999999","userName":"username"}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/user-info?T=dummy_token').
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new :auth_token => 'dummy_token'
    res = ino.user_info
    res.userId.should == '9999999999'
    res.userName.should == 'username'
  end

  it 'should get user id' do
    body = '{"userId":"9999999999","userName":"username","userProfileId":"9999999999","userEmail":"test_user@gmail.com","isBloggerUser":false,"signupTimeSec":1381980831,"isMultiLoginEnabled":false}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/user-info?T=dummy_token').
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    res = ino.user_id
    res.userId.should == '9999999999'
    res.keys.count.should == 1
  end

end