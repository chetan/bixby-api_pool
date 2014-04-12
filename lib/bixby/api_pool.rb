
require 'thread'
require 'actionpool'
require 'ethon'

require 'bixby/api_pool/request'
require 'bixby/api_pool/response'

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

      # GET the list of URLs
      def get(urls, key, client_pool_size=4)
        reqs = urls.map{ |u| Request.new(u) }
        APIPool.new(client_pool(key, client_pool_size), thread_pool).fetch(reqs)
      end

      def fetch(reqs, key, client_pool_size=4)
        reqs = [reqs] if not reqs.kind_of? Array
        APIPool.new(client_pool(key, client_pool_size), thread_pool).fetch(reqs)
      end

    end

    def initialize(client_pool, thread_pool)
      @mon = Splib::Monitor.new
      @client_pool = client_pool
      @thread_pool = thread_pool
      @completed = 0
      @total = 0
    end

    def fetch(reqs)
      @total = reqs.size
      ret = {}
      reqs.each_with_index do |r, i|

        @thread_pool.process {
          begin
            c = @client_pool.pop
            c.reset
            c.http_request(r.url, r.action, r.options)
            c.perform
            ret[i] = Response.new(c)
          ensure
            @completed += 1
            @client_pool << c
            @mon.broadcast if finished?
          end
        }
      end

      @mon.wait_while { !finished? }

      # sort of a cheap hack to return responses in the order they were requested
      # since we work with arrays of requests only, we need to maintain the same order going back
      return ret.keys.sort.map{ |k| ret[k] }
    end

    def finished?
      @total == @completed
    end

  end

end
