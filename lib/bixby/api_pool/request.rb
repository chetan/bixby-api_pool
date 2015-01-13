
module Bixby
  class APIPool
    class Request

      attr_accessor :uri, :url, :action, :options

      def initialize(url, action=:get, options=nil)
        @uri = url.kind_of?(URI) ? url : URI.parse(url)
        @url = url.to_s
        @action = action

        if options.nil? then
          @options = { :body => nil }
        elsif options.kind_of? String or (options.kind_of? Hash and !options.include? :body) then
          @options = { :body => options }
        else
          @options = options
        end
      end

      def to_net_http
        path = @uri.path
        path = "/" if !path || path.empty?
        if @action == :get then
          Net::HTTP::Get.new(path)
        elsif @action == :post then
          post = Net::HTTP::Post.new(path)
          if @options.include? :body then
            post.body = @options[:body]
          else
            post.set_form_data(@options)
          end
          post
        end
      end

    end
  end
end
