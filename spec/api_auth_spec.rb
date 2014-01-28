require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api auth' do

  it 'should correct auth' do
    set_auth_stub 'dummy_name', 'dummy_pass', 200, "SID=null\nLSID=null\nAuth=thisisdummyauthkey!321"
    res = InoreaderApi::Api.auth('dummy_name', 'dummy_pass')
    res[:auth_token].should == 'thisisdummyauthkey!321'
  end

  it 'should auth failed (unAuthorizing)' do
    set_auth_stub 'fail', 'pass', [400, 'Authorization Required'], 'Error=BadAuthentication'
    proc {
      InoreaderApi::Api.auth('fail', 'pass') { |http| http.request(req) }
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Authorization Required')
  end

  it 'should auth failed 500' do
    set_auth_stub 'error', 'pass', [500, 'Internal Server Error'], ''
    proc {
      InoreaderApi::Api.auth('error', 'pass') { |http| http.request(req) }
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Internal Server Error')
  end

  it 'should to timeout' do
    stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
      with(:body => 'Email=timeout_name&Passwd=fail_pass').to_timeout

    proc {
      InoreaderApi::Api.auth('timeout_name', 'fail_pass') { |http| http.request(req) }
    }.should raise_error(InoreaderApi::InoreaderApiError)
  end

  it 'should get token' do
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/token?T=dummy_token').
      to_return(:status => 200, :body => 'dummy_token', :headers => {})
    res = InoreaderApi::Api.token 'dummy_token'
    res.should == 'dummy_token'
  end

end