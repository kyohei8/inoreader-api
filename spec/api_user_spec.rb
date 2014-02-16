require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api#user' do

  it 'should get user info' do

    body = '{"userId":"9999999999","userName":"username"}'
    stub_request(:get, make_url(REQUEST_PATH[:user_info],{
      :T => 'dummy_token'
    })).to_return(
      :status => 200,
      :body => body,
      :headers => {}
    )

    res = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).user_info
    res.userId.should == '9999999999'
    res.userName.should == 'username'
  end
end