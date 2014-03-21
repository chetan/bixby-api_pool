
require 'thread'
require 'actionpool'
require 'ethon'

module Bixby
  class APIPool

    class << self

      def client_pool(key, size=4)
        if client_pools.include? key then
          return client_pools[key]
        end
        pool = client_pools[key] = Queue.new
        size.times{ pool << Ethon::Easy.new }
        pool
      end

      def client_pools
        @client_pools ||= {}
      end

      def thread_pool()
        @thread_pool ||= ActionPool::Pool.new(:max_threads => thread_pool_size)
      end

      def thread_pool_size=(val)
        @thread_pool_size = val
      end

      def thread_pool_size
        @thread_pool_size ||= 4
      end

      def get(urls, key, client_pool_size=4)
        APIPool.new(client_pool(key, client_pool_size), thread_pool).fetch(urls)
      end

      def post(urls, key, client_pool_size=4)
        APIPool.new(client_pool(key, client_pool_size), thread_pool).fetch(urls, :post)
      end

    end

    def initialize(client_pool, thread_pool)
      @mon = Splib::Monitor.new
      @client_pool = client_pool
      @thread_pool = thread_pool
      @completed = 0
      @total = 0
    end

    def fetch(urls, action=:get)
      @total = urls.size
      ret = {}
      urls.each_with_index do |u, i|

        url, options = extract_req(u)

        @thread_pool.process {
          begin
            c = @client_pool.pop
            c.reset
            c.http_request(url, action, options)
            c.perform
            ret[i] = c.response_body
          ensure
            @completed += 1
            @client_pool << c
            @mon.broadcast if finished?
          end
        }
      end

      @mon.wait_while { !finished? }
      return ret.keys.map{ |k| ret[k] }
    end

    def extract_req(u)
      options = nil
      if u.kind_of? Array then
        url, options = [u.shift, u.shift]
      elsif u.kind_of? String then
        url = u
      end

      if options.nil? then
        options = {}
      elsif options.kind_of? String or (options.kind_of? Hash and !options.include? :body) then
        options = { :body => options }
      end

      return [url, options]
    end

    def finished?
      @total == @completed
    end

  end

end
