require 'rspec'
require 'inoreader-api'

describe 'Test' do

  it 'should do something' do
    InoreaderApi::Api.auth('tet', 'test')
  end
end