require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api#token' do
  it 'should correct get token' do
    stub_request(:get, "https://www.inoreader.com/reader/api/0/token?T=dummy_token").
      to_return(
      :status  => 200,
      :body    => 'dummy_token',
      :headers => {}
    )

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    ino.token.should == 'dummy_token'
  end
end