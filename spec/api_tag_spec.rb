require 'rspec'
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe 'InoreaderApi::Api tag manipulation' do

  it 'should rename tag' do

    stub_request(:post, make_url(REQUEST_PATH[:rename_tag], {
      :T    => 'dummy_token',
      :dest => 'dest',
      :s    => 'source'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).rename_tag('source', 'dest').should == 'OK'
  end

  it 'should disable tag' do

    stub_request(:post, make_url(REQUEST_PATH[:disable_tag], {
      :T => 'dummy_token',
      :s => 'source'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).disable_tag('source').should == 'OK'
  end

  it 'should add tag' do
    stub_request(:post, make_url(REQUEST_PATH[:edit_tag], {
      :T => 'dummy_token',
      :i => 'item_id',
      :a => 'tag'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).add_tag('item_id', 'tag').should == 'OK'
  end

  it 'should remove tag' do
    stub_request(:post, make_url(REQUEST_PATH[:edit_tag], {
      :T => 'dummy_token',
      :i => 'item_id',
      :r => 'tag'
    })).to_return(
      :status  => 200,
      :body    => 'OK',
      :headers => {}
    )

    InoreaderApi::Api.new(
      :auth_token => 'dummy_token'
    ).remove_tag('item_id', 'tag').should == 'OK'
  end
end