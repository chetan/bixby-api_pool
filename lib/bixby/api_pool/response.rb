
require 'bixby/api_pool/headers'

module Bixby
  class APIPool
    class Response < Hash

      attr_accessor :body

      def initialize(client)
        @options = Ethon::Easy::Mirror.from_easy(client).options
        @body = client.response_body
        @header_str = client.response_headers
        @status_line = @status = @headers = nil
      end

      def headers
        @headers ||= parse_headers()
      end

      def return_code
        @options[:return_code]
      end

      def status
        headers.status
      end

      def status_line
        headers.status_line
      end

      def success?
        return_code == :ok && (status >= 200 && status < 300)
      end

      def redirect?
        return_code == :ok && (status == 301 || status == 302 || status == 303 || status == 307)
      end

      def error?
        return_code != :ok || (!redirect? && !success?)
      end


      private

      def parse_headers
        h = Headers.new(@header_str)
        @header_str = nil
        h
      end

    end
  end
end
