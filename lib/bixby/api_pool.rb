
require 'bixby-common'

require 'bixby/api_pool/request'
require 'bixby/api_pool/response'

require 'thread'
require 'net/http/persistent'

module Bixby
  class APIPool

    class << self

      def client_pool(key)
        @client_pool ||= Net::HTTP::Persistent.new(key)
      end

      def thread_pool
        min_size = thread_pool_size <= 4 ? 1 : 4
        @thread_pool ||= Bixby::ThreadPool.new(:min_size => min_size, :max_size => thread_pool_size)
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
      @client_pool = client_pool
      @thread_pool = thread_pool
    end

    def fetch(reqs)
      mon = Monitor.new
      sig = mon.new_cond

      ret = {}
      reqs.each_with_index do |r, i|
        @thread_pool.perform {
          begin
            ret[i] = Response.new(@client_pool.request(r.uri, r.to_net_http))
          rescue Net::HTTP::Persistent::Error => ex
            r = Response.new(nil)
            r.ex = ex
            ret[i] = r
          ensure
            mon.synchronize {
              sig.broadcast if ret.size == reqs.size
            }
          end
        }
      end

      mon.synchronize {
        sig.wait_while { ret.size != reqs.size }
      }

      # sort of a cheap hack to return responses in the order they were requested
      # since we work with arrays of requests only, we need to maintain the same order going back
      result = []
      reqs.size.times{ |i| result << ret[i] }
      return result
    end

  end

end
