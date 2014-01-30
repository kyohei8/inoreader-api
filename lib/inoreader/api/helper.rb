# coding: utf-8
require 'httparty'
require 'multi_json'
require 'hashie'

module InoreaderApi

  class Helper
    include HTTParty
    debug = true
    if debug
      debug_output $stdout
    end
    self.disable_rails_query_string_format

    base_uri 'https://www.inoreader.com'

    class << self
      # send request
      # @param [String] path request path
      # @param [Hash] query URL params  ex. {:query => {:T => 'token', :ref => 'bar'}}
      # @param [Symbol] method :get or :post
      # @param [Boolean] return_httpart_respqnse true to return the HTTParty::Response
      # @return response body
      def request(path, query=nil, method=:get, return_httparty_respqnse=false)
        begin
          response = self.send(method, "#{path}", query)
        rescue => e
          #request fail (ex. timeout)
          raise InoreaderApiError.new e.message
        end

        if response.response.code == '200'

          begin
            p response.body
            json = JSON.parse(response.body)
            p json
            p Hashie::Mash.new MultiJson.decode(response.body)
          rescue
            p 'ERROERRRRRRRRRR'
          end

          if return_httparty_respqnse
            response
          else
            #return to hashie
            response.body
          end

        else
          # request fail (ex. 500, 401...)
          raise InoreaderApiError.new response.response.message
        end
      end

      # auth request to Inoreader
      # @param [String] un username
      # @param [String] pw password
      # @return response body
      def auth_request(un, pw)
        request '/accounts/ClientLogin', {:body => {:Email => un, :Passwd => pw}}, :post
      end
    end
  end

end
