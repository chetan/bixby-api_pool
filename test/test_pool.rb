
require 'helper'
require 'net/http'
require 'timeout'

module Bixby
  class TestPool < Bixby::TestCase

    def setup
      super
      @test_server = TestServer.new
      @test_server.start
      @url = @test_server.url
    end

    def teardown
      super
      @test_server.stop
      pool = Bixby::APIPool.client_pool(@url)
      pool.shutdown
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
      assert_equal "3", res.response["Content-Length"]
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

    def test_timeout
      bad_url = "http://localhost:" + (TestServer.find_available_port()+1).to_s
      ret = Bixby::APIPool.get([bad_url], "test")
      assert ret
      assert_kind_of Array, ret
      assert_equal 1, ret.size

      res = ret.first
      refute res.success?
      refute res.redirect?
      assert res.error?
      assert_equal 0, res.status
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
      p ret.first
      assert_equal "post", ret.first.body
    end

  end
end
