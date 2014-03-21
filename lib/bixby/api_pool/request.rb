
module Bixby
  class APIPool
    class Request

      attr_accessor :url, :action, :options

      def initialize(url, action=:get, options={})
        @url = url
        @action = action

        if options.kind_of? String or (options.kind_of? Hash and !options.include? :body) then
          @options = { :body => options }
        else
          @options = options
        end
      end

    end
  end
end
