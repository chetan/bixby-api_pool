
require 'bixby/api_pool/headers'

module Bixby
  class APIPool
    class Response < Hash

      attr_reader :body, :details

      def initialize(client)
        @details = Ethon::Easy::Mirror.from_easy(client).options
        @details.delete(:debug_info)
        @body = client.response_body
        @status_line = @status = @headers = nil
      end

      def headers
        @headers ||= parse_headers()
      end

      def return_code
        @details[:return_code]
      end

      def status
        @status ||= @details[:response_code]
      end

      def status_line
        headers.status_line
      end

      def success?
        return_code == :ok && status && (status >= 200 && status < 300)
      end

      def redirect?
        return_code == :ok && status && (status == 301 || status == 302 || status == 303 || status == 307)
      end

      def error?
        return_code != :ok || (!redirect? && !success?)
      end


      private

      def parse_headers
        h = Headers.new(@details.delete(:response_headers))
        @header_str = nil
        h
      end

    end
  end
end
