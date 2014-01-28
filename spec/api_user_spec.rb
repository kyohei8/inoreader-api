require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api#user' do

  it 'should get user info' do

    body = '{"userId":"9999999999","userName":"username","userProfileId":"9999999999","userEmail":"test_user@gmail.com","isBloggerUser":false,"signupTimeSec":1381980831,"isMultiLoginEnabled":false}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/user-info?T=dummy_token').
      to_return(:status => 200, :body => body, :headers => {})

    res = InoreaderApi::Api.user_info('dummy_token')
    res.should == body
  end

  it 'get user info with bad token' do

    stub_request(:get, 'https://www.inoreader.com/reader/api/0/user-info?T=bad_token').
      to_return(:status => [401, 'Authorization Required'], :body => '', :headers => {})

    proc {
      InoreaderApi::Api.user_info('bad_token')
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Authorization Required')
  end

  it 'should get user id' do
    body = '{"userId":"9999999999","userName":"username","userProfileId":"9999999999","userEmail":"test_user@gmail.com","isBloggerUser":false,"signupTimeSec":1381980831,"isMultiLoginEnabled":false}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/user-info?T=dummy_token').
      to_return(:status => 200, :body => body, :headers => {})

    res = InoreaderApi::Api.user_id('dummy_token')
    res.should == '{"userId":"9999999999"}'
  end

end