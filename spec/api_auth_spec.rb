require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api auth' do

  it 'should correct auth' do
    set_auth_stub 'dummy_name', 'dummy_pass', 200, "SID=null\nLSID=null\nAuth=thisisdummyauthkey!321"
    ino = InoreaderApi::Api.new(
      :username => 'dummy_name',
      :password => 'dummy_pass'
    )
    ino.auth_token.should == 'thisisdummyauthkey!321'
  end

  it 'should auth failed (unAuthorizing)' do
    set_auth_stub 'fail', 'pass', [400, 'Authorization Required'], 'Error=BadAuthentication'
    proc {
      InoreaderApi::Api.new(
        :username => 'fail',
        :password => 'pass'
      )
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Authorization Required')
  end

  it 'should auth failed 500' do
    set_auth_stub 'error', 'pass', [500, 'Internal Server Error'], ''
    proc {
      InoreaderApi::Api.new(
        :username => 'error',
        :password => 'pass'
      )
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Internal Server Error')
  end

  it 'should to timeout' do
    stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
      with(:body => 'Email=timeout_name&Passwd=fail_pass').to_timeout

    proc {
      InoreaderApi::Api.new(
        :username => 'timeout_name',
        :password => 'fail_pass'
      )
    }.should raise_error(InoreaderApi::InoreaderApiError, 'execution expired')
  end

  it 'should get token' do
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/token?T=dummy_token').
      to_return(
      :status  => 200,
      :body    => 'dummy_token',
      :headers => {}
    )
    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    ino.instance_variable_get(:@auth_token).should == 'dummy_token'
  end
end