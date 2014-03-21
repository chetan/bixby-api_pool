
require 'helper'
require 'net/http'
require 'timeout'

module Bixby
  class TestPool < Bixby::TestCase

    def setup
      super
      start_server()
    end

    def teardown
      super
      stop_server()
    end

    def test_foo
      ret = Bixby::APIPool.get([@url], "test")
      assert ret
      flunk
    end


    private

    def start_server
      @port = find_available_port()
      TestApp.set(:port, @port)
      @url = "http://localhost:#{@port}"
      @server_thread = Thread.new do
        TestApp.run!
      end
      Timeout::timeout(5) do
        while !booted? do
          sleep 0.1
        end
      end
    end

    def stop_server
      TestApp.stop!
    end

    # wait for server to come up
    def booted?
      res = ::Net::HTTP.get_response(URI(@url))
      if res.is_a?(::Net::HTTPSuccess) or res.is_a?(::Net::HTTPRedirection)
        return res.body == "hi"
      end
    rescue Errno::ECONNREFUSED, Errno::EBADF
      return false
    end

    # find a random open tcp port
    def find_available_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end

  end
end
