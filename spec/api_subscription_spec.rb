require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api Subscription manipulation' do

  it 'should add Subscription' do
    url = 'http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:add_subscription], {
      :T        => 'dummy_token',
      :quickadd => url
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).add_subscription(url).should == 'OK'
  end

  it 'should rename Subscription' do
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:edit_subscription], {
      :T  => 'dummy_token',
      :ac => :edit,
      :s  => feed,
      :t  => 'new title'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).rename_subscription(feed, 'new title').should == 'OK'

  end

  it 'should add to folder a Subscription' do
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:edit_subscription], {
      :T  => 'dummy_token',
      :ac => :edit,
      :s  => feed,
      :a  => 'new folder'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).add_folder_subscription(feed, 'new folder').should == 'OK'
  end

  it 'should remove from Subscription to folder' do
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:edit_subscription], {
      :T  => 'dummy_token',
      :ac => :edit,
      :s  => feed,
      :r  => 'new folder'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).remove_folder_subscription(feed, 'new folder').should == 'OK'
  end

  it 'should unsubscribe' do
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:edit_subscription], {
      :T  => 'dummy_token',
      :ac => :unsubscribe,
      :s  => feed,
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).unsubscribe(feed).should == 'OK'
  end

  it 'should subscribe' do
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:get, make_url(REQUEST_PATH[:edit_subscription], {
      :T  => 'dummy_token',
      :ac => :subscribe,
      :s  => feed,
      :a  => 'new folder',
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).subscribe(feed, 'new folder').should == 'OK'
  end

end