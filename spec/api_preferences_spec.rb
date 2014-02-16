require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api preferences manipulation' do

  it 'should get preferences list' do
    body = '{ "prefs": [{"id": "lhn-prefs", "value": "{\"subscriptions\":{\"ssa\":\"false\"}}"}]}'
    stub_request(:get, make_url(REQUEST_PATH[:preference_list], {
      :T => 'dummy_token',
    })).to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).preferences_list['prefs'].should == [
      {
        "id"    => "lhn-prefs",
        "value" => "{\"subscriptions\":{\"ssa\":\"false\"}}"
      }]
  end


  it 'should get stream preferences list' do
    body = '{"streamprefs": { "root": [{"id":"subscription-ordering", "value": "00BED5"}]}}'

    stub_request(:get, make_url(REQUEST_PATH[:stream_preferences_list], {
      :T => 'dummy_token',
    })).to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )

    hashie_response = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).stream_preferences_list
    hashie_response.streamprefs.root[0].id.should == 'subscription-ordering'
    hashie_response.streamprefs.root[0].value.should == '00BED5'

  end

  it 'should set preferences list' do

    stub_request(:post, make_url(REQUEST_PATH[:set_stream_preferences], {
      :T => 'dummy_token',
      :k => 'subscription-ordering',
      :s => 'user/-/state/com.google/root',
      :v => '00A3AAB000B9C8F9',
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).set_subscription_ordering('user/-/state/com.google/root', '00A3AAB000B9C8F9').should == 'OK'
  end
end
