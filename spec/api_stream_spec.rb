require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'Inoreader::Api#stream' do

  it 'should get all item ids' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    stub_request(:get, make_url(REQUEST_PATH[:item_ids], {
      :T      => 'dummy_token',
      :output => 'json'
    })).to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )

    hashie_response = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).item_ids
    hashie_response.itemRefs[0].id.should == '9878'
    hashie_response.items == []

    httparty_response = InoreaderApi::Api.new(
      :auth_token => 'dummy_token',
      :return_httparty_response => true
    ).item_ids
    httparty_response.body.should == body

  end

  it 'should get feeds item ids' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:item_ids], {
      :T      => 'dummy_token',
      :n      => 10,
      :r      => 'o',
      :ot     => '1389756192',
      :xt     => 'user/-/state/com.google/read',
      :it     => 'user/-/state/com.google/read',
      :c      => 'asdfgqer',
      :output => 'json'
    }, feed)).to_return(
      :status => 200,
      :body => body,
      :headers => {}
    )

    hashie_response = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).item_ids(feed, {
      :n  => 10,
      :r  => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c  => 'asdfgqer'
    })
    hashie_response.itemRefs[0].id.should == '9878'
    hashie_response.items.should == []


    httparty_response = InoreaderApi::Api.new(
      :auth_token               => 'dummy_token',
      :return_httparty_response => true
    ).item_ids(feed, {
      :n  => 10,
      :r  => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c  => 'asdfgqer'
    })

    httparty_response.body.should == body
  end

  # check items api
  it 'should get all feed items' do
    body = '{"direction": "ltr","title": "Reading List","items":[{"id": "tag:00001"}]}'
    stub_request(:get, make_url(REQUEST_PATH[:items], {
      :T      => 'dummy_token',
      :output => 'json'
    })).
      to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )

    hashie_response = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).items
    hashie_response.direction.should == 'ltr'
    hashie_response.title.should == 'Reading List'
    hashie_response.items.count.should == 1
    hashie_response.items[0].id.should == 'tag:00001'

    httparty_response = InoreaderApi::Api.new(
      :auth_token               => 'dummy_token',
      :return_httparty_response => true
    ).items
    httparty_response.body.should == body
  end

  it 'should get feeds items' do
    body = '{"direction": "ltr","title": "feed1","items":[{"id": "tag:00001"}]}'
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:items], {
      :T  => 'dummy_token',
      :n  => 10,
      :r  => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c  => 'Beg3ah6v3',
      :output => 'json'
    },feed)).to_return(
      :status => 200,
      :body => body,
      :headers => {}
    )

    hashie_response = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).items(feed, {
      :n  => 10,
      :r  => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c  => 'Beg3ah6v3'
    })
    hashie_response.direction.should == 'ltr'
    hashie_response.title.should == 'feed1'
    hashie_response.items.count.should == 1
    hashie_response.items[0].id.should == 'tag:00001'

    httparty_response = InoreaderApi::Api.new(
      :auth_token               => 'dummy_token',
      :return_httparty_response => true
    ).items(feed, {
      :n  => 10,
      :r  => 'o',
      :ot => '1389756192',
      :xt => 'user/-/state/com.google/read',
      :it => 'user/-/state/com.google/read',
      :c  => 'Beg3ah6v3'
    })

    httparty_response.body.should == body
  end

end