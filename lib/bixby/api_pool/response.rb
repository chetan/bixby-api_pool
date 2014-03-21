
require 'bixby/api_pool/headers'

module Bixby
  class APIPool
    class Response < Hash

      attr_accessor :body

      def initialize(client)
        @body = client.response_body
        @header_str = client.response_headers
        @status_line = @status = @headers = nil
      end

      def headers
        @headers ||= parse_headers()
      end

      def status
        headers.status
      end

      def status_line
        headers.status_line
      end

      def success?
        status >= 200 && status < 300
      end

      def redirect?
        status == 301 || status == 302 || status == 303 || status == 307
      end

      def error?
        !redirect? && !success?
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
