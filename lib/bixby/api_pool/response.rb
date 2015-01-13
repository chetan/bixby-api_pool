
module Bixby
  class APIPool
    class Response

      attr_reader :response
      attr_accessor :ex

      def initialize(res)
        @response = res
        @ex = nil
      end

      def body
        @response.body
      end

      def status
        if @status.nil? then
          @status = @ex ? 0 : @response.code.to_i
        end
        @status
      end

      def success?
        !@ex && status && (status >= 200 && status < 300)
      end

      def redirect?
        !@ex && status && (status == 301 || status == 302 || status == 303 || status == 307)
      end

      def error?
        @ex || (!redirect? && !success?)
      end

    end
  end
end
