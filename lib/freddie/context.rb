require 'freddie/request'
require 'freddie/helpers'

module Freddie
  class Context
    include Helpers

    attr_reader   :request, :response, :remaining_path
    attr_accessor :layout

    def initialize(request, response)
      @request  = request
      @response = response
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout = nil

      @helpers = {}
    end

    def helper(name, &blk)
      @helpers[name.to_sym] = blk
    end

    def params
      request.params
    end

    def session
      request.session
    end

    def method_missing(name, *args, &blk)
      if helper_blk = @helpers[name.to_sym]
        helper_blk.call(*args, &blk)
      else
        super
      end
    end

    class << self
      def from_env(env)
        new(Freddie::Request.new(env), Rack::Response.new)
      end
    end
  end
end
