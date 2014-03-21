
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

    def test_simple_get
      ret = Bixby::APIPool.get([@url], "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 1, ret.size

      res = ret.first
      assert res.success?
      assert_equal "get", res.body
      assert_equal 200, res.status
      assert_equal "3", res.headers["Content-Length"]
    end

    def test_not_found
      ret = Bixby::APIPool.get([@url + "/404"], "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 1, ret.size

      res = ret.first
      refute res.success?
      refute res.redirect?
      assert res.error?
      assert_equal 404, res.status
    end

    def test_get_multiple
      ret = Bixby::APIPool.get([@url]*10, "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 10, ret.size
      ret.each do |s|
        assert_equal "get", s.body
      end
    end

    def test_post
      ret = APIPool.fetch(APIPool::Request.new(@url, :post), "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 1, ret.size
      assert_equal "post", ret.first.body
    end

    def test_post_multiple
      reqs = [APIPool::Request.new(@url, :post)]*10
      ret = Bixby::APIPool.fetch(reqs, "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 10, ret.size
      ret.each do |s|
        assert_equal "post", s.body
      end
    end

    def test_post_body
      req = APIPool::Request.new(@url, :post, MultiJson.dump({:foo => "hello json"}))
      ret = Bixby::APIPool.fetch(req, "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 1, ret.size
      assert_equal "post", ret.first.body
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
        return res.body == "get"
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
