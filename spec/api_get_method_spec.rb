require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api#unread_counters' do
  it 'should get unread count' do
    body = '{"max":"1000","unreadcounts":[{"id":"user\/9999999999\/state\/com.google\/reading-list","count":1000,"newestItemTimestampUsec":"1390821452642780"}]}'
    stub_request(:get, make_url(REQUEST_PATH[:unread_count], {
      :T      => 'dummy_token',
      :output => 'json'
    })).to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )
    res = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).unread_counters
    res[:max].should == '1000'
    res.unreadcounts[0].id == 'user/9999999999/state/com.google/reading-list'
    res.unreadcounts[0].count == 1000
    res.unreadcounts[0].newestItemTimestampUsec == '1390821452642780'
  end
end

describe 'InoreaderApi::Api#user_subscription' do
  it 'should get user subscription' do
    body = '{"subscriptions":[{ "id":"feed\/http:\/\/feeds.feedburner.com\/AjaxRain"}]}'
    stub_request(:get, make_url(REQUEST_PATH[:subscription], {
      :T => 'dummy_token'
    })).to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )

    res = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).user_subscription
    res.subscriptions[0].id.should == 'feed/http://feeds.feedburner.com/AjaxRain'
  end
end

describe 'InoreaderApi::Api#user_tags_folders' do
  it 'should get user tags' do
    body = '{"tags": [{ "id": "user\/9999999999\/state\/com.google\/starred", "sortid": "FFFFFFFF" }]}'
    stub_request(:get, make_url(REQUEST_PATH[:tag], {
      :T => 'dummy_token'
    })).to_return(
      :status  => 200,
      :body    => body,
      :headers => {}
    )

    res = InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).user_tags_folders
    res.tags[0].id.should == 'user/9999999999/state/com.google/starred'
    res.tags[0].sortid.should == 'FFFFFFFF'
  end
end