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

    attr_reader :options

    def initialize(delegate_app = nil, options = {})
      @delegate_app = delegate_app
      @options = options
    end

    def request
      local_or_delegate(:request)
    end

    def response
      local_or_delegate(:response)
    end

    def remaining_path
      local_or_delegate(:remaining_path)
    end

    def method_missing(name, *args, &blk)
      @delegate_app.try(name, *args, &blk) || super
    end

    def local_or_delegate(name)
      instance_variable_get("@#{name}") || @delegate_app.send(name)
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
