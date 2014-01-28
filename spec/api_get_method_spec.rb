require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api#unread_counters' do
  it 'should get unread count' do
    body = '{"max":"1000","unreadcounts":[{"id":"user\/9999999999\/state\/com.google\/reading-list","count":1000,"newestItemTimestampUsec":"1390821452642780"}]}'
    stub_request(:get, 'https://www.inoreader.com/reader/api/0/unread-count?T=dummy_token&output=json').
      to_return(:status => 200, :body => body, :headers => {})
    res = InoreaderApi::Api.unread_counters 'dummy_token'
    res.should == body
  end
end

describe 'InoreaderApi::Api#user_subscription' do

  it 'should get user subscription' do
    body = '{"subscriptions":[{ "id":"feed\/http:\/\/feeds.feedburner.com\/AjaxRain"}]}'
    stub_request(:get, "https://www.inoreader.com/reader/api/0/subscription/list?T=dummy_token").
      to_return(:status => 200, :body => body, :headers => {})

    res = InoreaderApi::Api.user_subscription 'dummy_token'
    res.should == body
  end

end

describe 'InoreaderApi::Api#user_tags_folders' do

  it 'should get user tags' do
    body = '{"tags": [{ "id": "user\/9999999999\/state\/com.google\/starred", "sortid": "FFFFFFFF" }]}'
    stub_request(:get, "https://www.inoreader.com/reader/api/0/tag/list?T=dummy_token").
      to_return(:status => 200, :body => body, :headers => {})
    res = InoreaderApi::Api.user_tags_folders 'dummy_token'
    res.should == body
  end
end