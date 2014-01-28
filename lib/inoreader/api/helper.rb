# coding: utf-8
require 'httparty'

module InoreaderApi

  class Helper
    include HTTParty
    debug = false
    if debug
      debug_output $stdout
    end
    self.disable_rails_query_string_format

    INOREADER_BASE_URL = 'https://www.inoreader.com'

    class << self
      # send request
      # @param [String] path request path
      # @param [Hash] query URL params  ex. {:query => {:T => 'token', :ref => 'bar'}}
      # @param [Symbol] method :get or :post
      # @return response body
      def request(path, query=nil, method=:get)
        begin
          response = self.send(method, "#{INOREADER_BASE_URL}#{path}", query)
        rescue => e
          #request fail (ex. timeout)
          raise InoreaderApiError.new e.message
        end

        if response.response.code == '200'
          response.body
        else
          # request fail (ex. 500, 401...)
          raise InoreaderApiError.new response.response.message
        end
      end

      # send request for attach a 'GoogleLogin auth' to request header
      # @param [String] path request path
      # @param [Hash] query URL parameter, without token  ex. {:query => {:q => 'foo', :ref => 'bar'}}
      # @param [Symbol] method :get or :post
      # @return response body
      #def request_with_token(path, token, query=nil, method=:get)
      #  raise 'Error: not authorized' if token.nil?
      #  option = {:headers => {'Authorization' => 'GoogleLogin auth=' + token}}
      #  option[:query] = query unless query.nil?
      #  self.send(method, "#{INOREADER_BASE_URL}#{path}", option).body
      #rescue => e
      #  raise InoreaderApiError.new "Network Error:#{e.message}"
      #end

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
