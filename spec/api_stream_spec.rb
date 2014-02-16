require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'Inoreader::Api#stream' do

  it 'should get all item ids' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    params = {
      :T => 'dummy_token',
      :output => 'json'
    }

    stub_request(:get, make_url(REQUEST_PATH[:item_ids], params)).
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    hashie_response = ino.item_ids
    hashie_response.itemRefs[0].id.should == '9878'
    hashie_response.items == []

    ino1 = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    httparty_response = ino1.item_ids
    httparty_response.body.should == body

  end

  it 'should get feeds item ids' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    params = {
      :T => 'dummy_token',
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'asdfgqer',
      :output => 'json'
    }

    stub_request(:get, make_url(REQUEST_PATH[:item_ids], params, feed)).
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    hashie_response = ino.item_ids(feed, {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'asdfgqer',
      :output => 'json',
    })
    hashie_response.itemRefs[0].id.should == '9878'
    hashie_response.items.should == []


    ino1 = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    httparty_response = ino1.item_ids(feed, {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'asdfgqer'
    })

    httparty_response.body.should == body
  end

  # check items api
  it 'should get all feed items' do
    body = '{"direction": "ltr","title": "Reading List","items":[{"id": "tag:00001"}]}'
    params = {
      :T => 'dummy_token',
      :output => 'json'
    }

    stub_request(:get, make_url(REQUEST_PATH[:items], params)).
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    hashie_response = ino.items
    hashie_response.direction.should == 'ltr'
    hashie_response.title.should == 'Reading List'
    hashie_response.items.count.should == 1
    hashie_response.items[0].id.should == 'tag:00001'

    ino1 = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    httparty_response = ino1.items
    httparty_response.body.should == body
  end

  it 'should get feeds items' do
    body = '{"direction": "ltr","title": "feed1","items":[{"id": "tag:00001"}]}'
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    params = {
      :T => 'dummy_token',
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'Beg3ah6v3',
      :output => 'json'
    }

    stub_request(:get, make_url(REQUEST_PATH[:items], params, feed)).
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token')
    hashie_response = ino.items(feed, {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'Beg3ah6v3',
      :output => 'json',
    })
    hashie_response.direction.should == 'ltr'
    hashie_response.title.should == 'feed1'
    hashie_response.items.count.should == 1
    hashie_response.items[0].id.should == 'tag:00001'

    ino1 = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    httparty_response = ino1.items(feed, {
      :n => 10,
      :r => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c => 'Beg3ah6v3'
    })

    httparty_response.body.should == body
  end

end