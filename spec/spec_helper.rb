# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
require 'inoreader-api'
require 'webmock/rspec'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered                = true
  config.filter_run :focus
  config.include WebMock::API

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end


BASE_URL     = 'https://www.inoreader.com'
REQUEST_PATH = {
  :user_info               => '/reader/api/0/user-info',
  :token                   => '/reader/api/0/token',
  :unread_count            => '/reader/api/0/unread-count',
  :subscription            => '/reader/api/0/subscription/list',
  :tag                     => '/reader/api/0/tag/list',
  :items                   => '/reader/atom',
  :item_ids                => '/reader/api/0/stream/items/ids',
  :rename_tag              => '/reader/api/0/rename-tag',
  :disable_tag             => '/reader/api/0/disable-tag',
  :edit_tag                => '/reader/api/0/edit-tag',
  :mark_all_as_read        => '/reader/api/0/mark-all-as-read',
  :add_subscription        => '/reader/api/0/subscription/quickadd',
  :edit_subscription       => '/reader/api/0/subscription/edit',
  :preference_list         => '/reader/api/0/preference/list',
  :stream_preferences_list => '/reader/api/0/preference/stream/list',
  :set_stream_preferences  => '/reader/api/0/preference/stream/set'
}

# generate auth stub
def set_auth_stub(un, pass, status, body)
  stub_request(:post, 'https://www.inoreader.com/accounts/ClientLogin').
    with(:body => "Email=#{un}&Passwd=#{pass}").
    to_return(:status => status, :body => body, :headers => {})
end

# make Request Url to Inoreader APIs
def make_url(path, params, feed='')
  feed = '/' + feed unless feed.empty?
  "#{BASE_URL}#{path}#{feed}?#{URI.encode_www_form(params)}"
end
