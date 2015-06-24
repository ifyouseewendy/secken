require 'net/http'
require 'digest'
require 'json'

module Secken
  class Client
    attr_reader :config

    def initialize
      yield( @config = Configuration.new )
    end

    def qrcode_for_binding
      url = 'https://api.yangcong.com/v2/qrcode_for_binding'
      request(:get, url, { app_id: config.app_id })
    end

    private

      def sign_on(params)
        content = params.sort_by{|k,v| k}.map{|ar| ar.join('=')}.join('') + config.app_key
        Digest::MD5.hexdigest(content)
      end

      def request(method, url, params)
        if method == :get
          signed_params = params.merge({signature: sign_on(params)})
          query = query_string_from signed_params
          uri   = URI( [url, query].join('?') )

          puts "--> GET #{uri}"
          JSON.parse(Net::HTTP.get uri).tap{|resp| puts resp}
        elsif method == :post
          valid_keys = [:action_type, :app_id, :uid]
          signed_params = params.merge({signature: sign_on(params.select{|k,v| valid_keys.include? k})})
          uri = URI(url)

          puts "--> POST #{url} with #{signed_params}"

          JSON.parse(Net::HTTP.post_form(URI(url), params).body).tap{|resp| puts resp}
        end
      end

      def query_string_from(hash)
        hash.map{|ar| ar.join('=')}.join('&')
      end

  end
end



