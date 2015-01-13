
require 'thread'
require 'actionpool'
require 'net/http/persistent'

require 'bixby/api_pool/request'
require 'bixby/api_pool/response'

module Bixby
  class APIPool

    class << self

      def client_pool(key)
        @client_pool ||= Net::HTTP::Persistent.new(key)
      end

      def thread_pool
        @thread_pool ||= ActionPool::Pool.new(:max_threads => thread_pool_size)
      end

      def thread_pool_size=(val)
        @thread_pool_size = val
      end

      def thread_pool_size
        @thread_pool_size ||= 4
      end

      # GET the list of URLs
      def get(urls, key)
        reqs = urls.map{ |u| Request.new(u) }
        APIPool.new(client_pool(key), thread_pool).fetch(reqs)
      end

      def fetch(reqs, key)
        reqs = [reqs] if not reqs.kind_of? Array
        APIPool.new(client_pool(key), thread_pool).fetch(reqs)
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
            ret[i] = Response.new(@client_pool.request(r.uri, r.to_net_http))
          rescue Net::HTTP::Persistent::Error => ex
            r = Response.new(nil)
            r.ex = ex
            ret[i] = r
          ensure
            @completed += 1
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
