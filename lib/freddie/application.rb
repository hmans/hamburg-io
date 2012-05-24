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

    def method_missing(name, *args, &blk)
      @delegate_app.respond_to?(name) ?
        @delegate_app.send(name, *args, &blk) : super
    end

    def params
      request.params
    end

    def session
      request.session
    end

    def handle_request
      instance_exec(&self.class.request_blk) if self.class.request_blk
    end

    class << self
      attr_reader :request_blk

      def handle_request(&blk)
        @request_blk = blk
      end
    end
  end
end
