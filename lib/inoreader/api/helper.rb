# coding: utf-8
require 'httparty'
require 'multi_json'
require 'hashie'

module InoreaderApi
  class Helper
    include HTTParty

    attr_accessor :ret

    debug = false
    if debug
      debug_output $stdout
    end
    self.disable_rails_query_string_format

    base_uri 'https://www.inoreader.com'

    class << self

      # option: use httparty respqnse if set true
      @@return_httparty_response = false

      def return_httparty_response=(bool)
        @@return_httparty_response = bool
      end


      # send request
      # @param [String] path request path
      # @param [Hash] query URL params  ex. {:query => {:T => 'token', :ref => 'bar'}}
      # @param [Symbol] method :get or :post
      # @return response body
      def request(path, query=nil, method=:get)

        begin
          response = self.send(method, path, query)
        rescue => e
          #request fail (ex. timeout)
          raise InoreaderApiError.new e.message
        end

        if response.response.code == '200'
          if @@return_httparty_response
            response
          else
            begin
              #return to hashie
              Hashie::Mash.new MultiJson.decode(response.body)
            rescue
              # its not JSON, return body directly.
              response.body
            end
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
        response = self.post('/accounts/ClientLogin', {:body => {:Email => un, :Passwd => pw}})
        if response.response.code == '200'
          # request fail (ex. 500, 401...)
          response.body
        else
          raise InoreaderApiError.new response.response.message
        end
      end
    end
  end
end
