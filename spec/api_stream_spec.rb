require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'Inoreader::Api#stream' do
  it 'should get all item ids' do
    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/stream/items/ids?T=dummy_token&output=json').
      to_return(:status => 200, :body => body, :headers => {})
    hashie_response = ino.item_ids
    hashie_response.itemRefs[0].id.should == '9878'
    hashie_response.items == []
  end

  it 'should get one feed item ids' do
    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/stream/items/ids/feed/http://feeds.feedburner.com/AjaxRain?T=dummy_token&n=10&r=o&ot=1389756192&xt=user/-/state/com.google/read&it=user/-/state/com.google/read&c=asdfgqer&output=json').
      to_return(:status => 200, :body => body, :headers => {})
    hashie_response = ino.item_ids('feed/http://feeds.feedburner.com/AjaxRain', {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'asdfgqer',
      :output => 'json',
    })

    hashie_response.itemRefs[0].id.should == '9878'
    hashie_response.items == []
  end

  it 'should get all item ids with Httparty' do
    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/stream/items/ids?T=dummy_token&output=json').
      to_return(:status => 200, :body => body, :headers => {})
    httparty_response = ino.item_ids
    httparty_response.body.should == body
  end

  it 'should get one feed item ids with Httparty' do
    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/stream/items/ids/feed/http://feeds.feedburner.com/AjaxRain?T=dummy_token&n=10&r=o&ot=1389756192&xt=user/-/state/com.google/read&it=user/-/state/com.google/read&c=Beg3ah6v3&output=json').
      to_return(:status => 200, :body => body, :headers => {})

    httparty_response = ino.item_ids('feed/http://feeds.feedburner.com/AjaxRain', {
      :n => 10, :r => 'o', :ot => '1389756192', :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read', :c => 'Beg3ah6v3'
    })

    httparty_response.body.should == body
  end

end