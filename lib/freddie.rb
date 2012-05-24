module Freddie
  class Application

    def call(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new

      catch :done do
        handle_request
        serve! "<h1>404 Not Found</h1>", status: 404
      end

      @response
    end

    def handle_request
      # implement this in a subclass
    end

    def serve!(what, options = {})
      @response.status = options[:status] if options.has_key?(:status)

      @response.body = [what]
      halt!
    end

    def halt!(message = :done)
      throw message
    end

    class << self
      def call(env)
        new.call(env)
      end
    end
  end
end
