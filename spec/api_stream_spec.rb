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
  end

  it 'should get one feed item ids' do
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    feed = '/feed/http://feeds.feedburner.com/AjaxRain'
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
    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    params = {
      :T => 'dummy_token',
      :output => 'json'
    }

    stub_request(:get, make_url(REQUEST_PATH[:item_ids], params)).
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    httparty_response = ino.item_ids
    httparty_response.body.should == body
  end

  it 'should get one feed item ids with Httparty' do

    body = '{"items":[],"itemRefs":[{"id":"9878"}]}'
    feed = '/feed/http://feeds.feedburner.com/AjaxRain'
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

    stub_request(:get, make_url(REQUEST_PATH[:item_ids], params, feed)).
      to_return(:status => 200, :body => body, :headers => {})

    ino = InoreaderApi::Api.new(:auth_token => 'dummy_token', :return_httparty_response => true)
    httparty_response = ino.item_ids('feed/http://feeds.feedburner.com/AjaxRain', {
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