
require "puma"

module Bixby
  class TestServer

    class << self
      # find a random open tcp port
      def find_available_port
        if @port.nil? then
          server = TCPServer.new('127.0.0.1', 0)
          @port = server.addr[1]
        end
        @port
      ensure
        server.close if server
      end
    end

    attr_reader :url

    def initialize()
      @port = TestServer.find_available_port()
    end

    def start
      TestApp.set(:port, @port)
      TestApp.set(:server, :puma)
      @url = "http://localhost:#{@port}"

      @server = Puma::Server.new(TestApp.new)
      @server.add_tcp_listener "127.0.0.1", @port
      @server.run

      Timeout::timeout(3) do
        while !booted? do
          sleep 0.1
        end
      end
    end

    def stop
      @server.stop(true)
    end

    # wait for server to come up
    def booted?
      res = ::Net::HTTP.get_response(URI.join(@url, "/boot"))
      if res.is_a?(::Net::HTTPSuccess) or res.is_a?(::Net::HTTPRedirection)
        return res.body == "booted"
      end
    rescue Errno::ECONNREFUSED, Errno::EBADF
      return false
    end

  end
end
