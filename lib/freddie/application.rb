require 'freddie/request'
require 'freddie/routing'
require 'freddie/actions'
require 'freddie/rackable'
require 'freddie/helpers'

module Freddie
  class Application
    include Routing
    include Actions
    include Rackable
    include Helpers

    attr_reader :options, :request, :response, :remaining_path

    def initialize(delegate_app = nil, options = {})
      if @delegate_app = delegate_app
        @request = delegate_app.request
        @response = delegate_app.response
        @remaining_path = delegate_app.remaining_path
      end

      @options = options
    end

    def params
      request.params
    end

    def session
      request.session
    end

    def route
      instance_exec(&self.class.route_blk) if self.class.route_blk
    end

    class << self
      attr_reader :route_blk

      def route(&blk)
        @route_blk = blk
      end
    end
  end
end
