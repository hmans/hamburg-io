require 'active_support/all'

require 'freddie/routing'
require 'freddie/actions'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end

  class Application
    include Routing
    include Actions

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

    def call(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout = nil

      catch :done do
        serve! handle_request

        # If we get here, #serve decided not to serve.
        raise NotFoundError
      end

      @response
    end

    def handle_request
      # implement this in a subclass
    end

    class << self
      def call(env)
        new.call(env)
      end
    end
  end
end
