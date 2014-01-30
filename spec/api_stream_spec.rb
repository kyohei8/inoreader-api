require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'Inoreader::Api#stream' do
  body = '<?xml version="1.0" encoding="UTF-8"?><feed xmlns="http://www.w3.org/2005/Atom"><?feed>'

  it 'should should get all feed item data' do
    stub_request(:get, 'https://www.inoreader.com/reader/atom?T=dummy_token').
      to_return(:status => 200, :body => body, :headers => {})
    res = InoreaderApi::Api.items('dummy_token')
    res.should == body
  end

  it 'should should get one feed item data' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/atom/feed/http://feeds.feedburner.com/AjaxRain?T=dummy_token&n=10&r=o&ot=1389756192&xt=user/-/state/com.google/read&it=user/-/state/com.google/read&c=asdfgqer&output=json').
      to_return(:status => 200, :body => body, :headers => {})
    res = InoreaderApi::Api.items('dummy_token', 'feed/http://feeds.feedburner.com/AjaxRain', {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'asdfgqer',
      :output => 'json',
    })
    res.should == body
  end

  it 'should should get all item ids' do
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/stream/items/ids?T=dummy_token').
      to_return(:status => 200, :body => body, :headers => {})
    res = InoreaderApi::Api.item_ids('dummy_token')
    res.should == body
  end

  it 'should should get one feed item ids' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/stream/items/ids/feed/http://feeds.feedburner.com/AjaxRain?T=dummy_token&n=10&r=o&ot=1389756192&xt=user/-/state/com.google/read&it=user/-/state/com.google/read&c=asdfgqer&output=json').
      to_return(:status => 200, :body => body, :headers => {})
    res = InoreaderApi::Api.item_ids('dummy_token', 'feed/http://feeds.feedburner.com/AjaxRain', {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'asdfgqer',
      :output => 'json',
    })
    res.should == body
  end

end