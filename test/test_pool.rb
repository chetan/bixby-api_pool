
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
      assert_equal :ok, res.return_code
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
      assert_equal :ok, res.return_code
    end

    def test_timeout
      bad_url = "http://localhost:" + find_available_port().to_s
      ret = Bixby::APIPool.get([bad_url], "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 1, ret.size

      res = ret.first
      refute res.success?
      refute res.redirect?
      assert res.error?
      assert_equal 0, res.status
      assert_equal :couldnt_connect, res.return_code
    end

    # check that we get our responses back in the same order they were sent
    def test_get_multiple
      urls = []
      10.times{ |i| urls << URI.join(@url, "/echo/#{i}") }
      ret = Bixby::APIPool.get(urls, "test")

      assert ret
      assert_kind_of Array, ret
      assert_equal 10, ret.size

      ret.each_with_index do |s, i|
        assert_equal "echo #{i}", s.body
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
      TestApp.set(:server, :puma)
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
      if @server_thread && @server_thread.alive? then
        TestApp.stop!
        # @server_thread.join
      end
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

    # find a random open tcp port
    def find_available_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end

  end
end
