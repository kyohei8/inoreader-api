require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api mark all as read manipulation' do

  it 'should mark all as read ' do
    feed = 'feed/http://feeds.feedburner.com/AjaxRain'
    stub_request(:post, make_url(REQUEST_PATH[:mark_all_as_read], {
      :T  => 'dummy_token',
      :ts => 1373407120123456,
      :s  => feed
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).mark_all_as_read(1373407120123456, feed).should == 'OK'

  end
end