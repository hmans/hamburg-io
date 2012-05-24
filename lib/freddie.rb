require 'active_support/all'

require 'freddie/routing'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end

  class Application
    include Routing

    attr_reader :request, :response, :remaining_path

    def call(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }

      catch :done do
        handle_request
        raise NotFoundError
      end

      @response
    end

    def handle_request
      # implement this in a subclass
    end

    def serve!(what, options = {})
      # only serve if no path is remainng
      return unless remaining_path.empty?

      # add optional headers et al
      @response.status = options[:status] if options.has_key?(:status)
      @response['Content-type'] = options[:content_type] if options.has_key?(:content_type)

      # set response body and finish request
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
