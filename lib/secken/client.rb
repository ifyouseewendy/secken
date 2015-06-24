require 'net/http'
require 'cgi'
require 'digest'
require 'json'

module Secken
  class Client
    attr_reader :config

    def initialize
      yield( @config = Configuration.new )
    end

    def qrcode_for_binding(options = {})
      url = 'https://api.yangcong.com/v2/qrcode_for_binding'
      request(:get, url, { app_id: config.app_id , callback: options[:callback]})
    end

    def qrcode_for_auth(options = {})
      url = 'https://api.yangcong.com/v2/qrcode_for_auth'
      request(:get, url, { app_id: config.app_id , callback: options[:callback]})
    end

    private

      def sign_on(params)
        content = params.sort_by{|k,v| k}.map{|ar| ar.join('=')}.join('') + config.app_key
        Digest::MD5.hexdigest(content)
      end

      def request(method, url, params, valid_keys = [:app_id])
        signature = sign_on(params.select{|k,v| valid_keys.include? k})
        signed_params = params.merge({signature: signature})

        if method == :get
          query = query_string_from signed_params
          uri   = URI( [url, query].join('?') )

          puts "--> GET #{uri}"
          JSON.parse(Net::HTTP.get uri).tap{|resp| puts resp}
        elsif method == :post

          puts "--> POST #{url} with #{signed_params}"
          JSON.parse(Net::HTTP.post_form(URI(url), signed_params).body).tap{|resp| puts resp}
        end
      end

      def query_string_from(hash)
        hash.map{|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.join('&')
      end

  end
end



