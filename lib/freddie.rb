module Freddie
  class Application

    def call(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new

      catch :done do
        handle_request
        raise "404"
      end

      @response
    end

    def handle_request
      @response.body << "hi!"
      throw :done
    end

    class << self
      def call(env)
        new.call(env)
      end
    end
  end
end
