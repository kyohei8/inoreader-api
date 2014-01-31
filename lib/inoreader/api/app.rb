# coding: utf-8
require 'json'

module InoreaderApi
  class Api
    # set auth toke or username/password
    # @param [Hash] options
    # @option auth_token [String] auth token
    # @option username [String] username
    # @option password [String] password
    # @option return_httparty_response [Boolean]
    # @return [String] auth token
    def initialize(options={})
      # set default
      options = {
        :return_httparty_response => false
      }.merge(options)
      @auth_token = options.delete(:auth_token)
      if !@auth_token && options.has_key?(:username) && options.has_key?(:password)
        username = options.delete(:username)
        password = options.delete(:password)
        res = login(username, password)
        @auth_token = res
      end

      InoreaderApi::Helper.return_httparty_response = options[:return_httparty_response]
    end

    # return to auth token
    def auth_token
      @auth_token
    end

    # get user info
    # @return [String] json string "{"userId":"XXXXXXXXX", "userName":"user_name", ...}"
    def user_info
      Helper.request '/reader/api/0/user-info', {:query => {:T => @auth_token}}
    end

    # get user id
    # @return [String] json string "{userId : XXXXXXXX}"
    def user_id
      Hashie::Mash.new(:userId => user_info.userId)
    end

    # get token
    # @return [String] token. ex."aFP4xIm2Ow...."
    def token
      Helper.request '/reader/api/0/token', {:query => {:T => @auth_token}}
    end

    # OPML Import
    def import
      # todo
    end

    # get unread counters
    def unread_counters
      Helper.request '/reader/api/0/unread-count?output=json', {:query => {:T => @auth_token}}
    end

    # get user subscriptions
    def user_subscription
      Helper.request '/reader/api/0/subscription/list', {:query => {:T => @auth_token}}
    end

    # get user tags/folders
    def user_tags_folders
      Helper.request '/reader/api/0/tag/list', {:query => {:T => @auth_token}}
    end

    # stream
    #  output format : json only
    # @param [String] path request path
    # @param [String] feed id of subscription
    # @param [Hash] params request Parameters
    # @option params [Number] :n Number of items. (default 20, max 1000)
    # @option params [String] :r Order. (default is newest first. 'o' is oldest first)
    # @option params [String] :ot Start time (unix timestamp. ex.1389756192)
    # @option params [String] :xt Exclude Target. (ex. 'user/-/state/com.google/read')
    # @option params [String] :it Include Target. ('user/-/state/com.google/read(,starred,like)')
    # @option params [String] :c Continuation.
    def stream(path, feed='', params={})
      query = {:query => params.merge!(:T => @auth_token, :output => 'json')}
      feed_name = feed.empty? ? '' : '/' + feed
      Helper.request "#{path}#{feed_name}", query
    end

    # get user items
    # @see InoreaderApi::Api#stream
    def items(feed='', params={})
      stream '/reader/atom', feed, params
    end

    # get user item ids
    # @see InoreaderApi::Api#stream
    def item_ids(feed='', params={})
      stream '/reader/api/0/stream/items/ids', feed, params
    end

    ## tag ##

    # rename tag
    # @param source source tag
    # @param dest   dest tag
    def rename_tag(source, dest)
      Helper.request '/reader/api/0/rename-tag', {:query => {:T => @auth_token, s: source, dest: dest}}
    end

    # delete(disable) tag
    def disable_tag(tag_name)
      Helper.request '/reader/api/0/disable-tag', {:query => {:T => @auth_token, s: tag_name}}
    end

    # add tag
    # @param [String] items Item IDs(short or long)
    # @param [String] add_tag use SpecialTag or custom tag
    def add_tag(items, add_tag=nil)
      Helper.request '/reader/api/0/edit-tag', {:query => {:T => @auth_token, :i => items, :a => add_tag}}
    end

    # remove tag
    # @param [Array] items Item IDs(short or long)
    # @param [String] remove_tag SpecialTag or custom tag
    def remove_tag(items, remove_tag)
      Helper.request '/reader/api/0/edit-tag', {:query => {:T => @auth_token, :i => items, :r => remove_tag}}
    end

    # mark all as read. mark as read, older than ts.
    # @param [String] ts microseconds.
    # @param [String] s Stream.
    def mark_all_as_read(ts, s)
      Helper.request '/reader/api/0/mark-all-as-read', {:query => {:T => @auth_token, :ts => ts, :s => s}}
    end

    # add Subscription
    # @param [String] url specify the URL to add.
    def add_subscription(url)
      Helper.request '/reader/api/0/subscription/quickadd', {:query => {:T => @auth_token, quickadd: url}}
    end

    # edit subscription
    # @param [String] ac action ('edit' or 'subscribe' or 'unsubscribe')
    # @param [String] s stream id(feed/feed_url)
    # @param [String] t subscription title. Omit this parameter to keep the title unchanged
    # @param [String] a add subscription to folder/tag.
    # @param [String] r remove subscription from folder/tag.
    def edit_subscription(ac, s, t=nil, a=nil, r=nil)
      query = {:T => @auth_token, :ac => ac, :s => s}
      query[:t] = t unless t.nil?
      query[:a] = a unless a.nil?
      query[:r] = r unless r.nil?
      Helper.request '/reader/api/0/subscription/edit', {:query => query}
    end

    # rename subscription title
    # @param [String] s stream id(feed/feed_url)
    # @param [String] t subscription new title.
    def rename_subscription(token, s, t)
      edit_subscription token, :edit, s, t
    end

    # add folder to subscription
    # @param [String] s stream id(feed/feed_url)
    # @param [String] a add subscription to folder
    def add_folder_subscription(s, a)
      edit_subscription :edit, s, nil, a
    end

    # remove folder to subscription
    # @param [String] s stream id(feed/feed_url)
    # @param [String] r remove subscription to folder
    def remove_folder_subscription(s, r)
      edit_subscription :edit, s, nil, nil, r
    end

    # unsubscribe
    # @param [String] s stream id(feed/feed_url)
    def unsubscribe(s)
      edit_subscription :unsubscribe, s
    end

    # subscribe (=add Subscription)
    # @param [String] s stream id(feed/feed_url)
    # @param [String] a folder name
    def subscribe(s, a)
      edit_subscription :subscribe, s, nil, a
    end

    # preference list:current subscriptions sorting.
    def preferences_list
      Helper.request '/reader/api/0/preference/list', {:query => {:T => @auth_token}}
    end

    # Stream preferences list
    def stream_preferences_list
      Helper.request '/reader/api/0/preference/stream/list', {:query => {:T => @auth_token}}
    end

    # @param [String] s stream id. root or folder name
    # @param [String] k key
    # @param [String] v value
    def set_stream_preferences(s, k, v)
      query = {:query => {:T => @auth_token, :s => s, :k => k, :v => v}}
      Helper.request '/reader/api/0/preference/stream/set', query, :post
    end

    # Set stream preferences. now is “subscription-ordering” only :P
    # @param [String] s stream id. root or folder name
    # @param [String] v sorting value
    def set_subscription_ordering(s, v)
      set_stream_preferences(s, 'subscription-ordering', v)
    end

    private
    # Authenticate, to return authToken
    # @param un username or Email
    # @param pw Password
    # @return Hash
    # if success
    # {
    #   :auth_token => xxxxxxxx
    # }
    #
    def login(un, pw)
      response_body = Helper.auth_request un, pw
      auth_token = Hash[*response_body.split.collect { |i| i.split('=') }.flatten]['Auth']
      raise InoreaderApi::InoreaderApiError.new 'Bad Authentication' if auth_token.nil?
      auth_token
    rescue => e
      raise InoreaderApi::InoreaderApiError.new e.message if auth_token.nil?
    end
  end
end