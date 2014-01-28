require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api auth' do
  it 'should correct auth' do
    # collect auth
    body = <<-EOS
      SID=null
      LSID=null
      Auth=thisisdummyauthkey!321
    EOS

    stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
      with(:body => 'Email=dummy_name&Passwd=dummy_pass').
      to_return(:status => 200, :body => body, :headers => {})

    res = InoreaderApi::Api.auth('dummy_name', 'dummy_pass')
    res[:auth_key].should == 'thisisdummyauthkey!321'
  end

  it 'should auth failed (unAuthorizing)' do

    stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
      with(:body => 'Email=fail_name&Passwd=fail_pass').
      to_return(:status => [400, 'Authorization Required'], :body => 'Error=BadAuthentication', :headers => {})
    proc {
      InoreaderApi::Api.auth('fail_name', 'fail_pass') {|http| http.request(req)}
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Authorization Required')
  end

  it 'should auth failed 500' do

    stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
      with(:body => 'Email=error_name&Passwd=fail_pass').
      to_return(:status => [500, 'Internal Server Error'], :body => '', :headers => {})

    proc {
      InoreaderApi::Api.auth('error_name', 'fail_pass') {|http| http.request(req)}
    }.should raise_error(InoreaderApi::InoreaderApiError, 'Internal Server Error')

  end

  it 'should to timeout' do
    stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
      with(:body => 'Email=timeout_name&Passwd=fail_pass').to_timeout

    proc {
      InoreaderApi::Api.auth('timeout_name', 'fail_pass') {|http| http.request(req)}
    }.should raise_error(InoreaderApi::InoreaderApiError)
  end

end