require 'active_support/all'

require 'freddie/routing'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end

  class Application
    include Routing

    attr_reader :request, :response, :remaining_path

    delegate :params, :to => :request

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

    def serve!(data, options = {})
      return unless remaining_path.empty?
      return unless data.is_a?(String)

      # mix in default options
      options = {
        layout: @layout
      }.merge(options)

      # add optional headers et al
      @response.status = options[:status] if options.has_key?(:status)
      @response['Content-type'] = options[:content_type] if options.has_key?(:content_type)

      # apply layout
      if options[:layout]
        data = render(options[:layout]) { data }
      end

      # set response body and finish request
      @response.body = [data]
      halt!
    end

    def halt!(message = :done)
      throw message
    end

    def render(what, options = {}, &blk)
      case what
        when String then Niles::Templates.render(what, self, &blk)
      end
    end

    def layout(name)
      @layout = name
    end

    class << self
      def call(env)
        new.call(env)
      end
    end
  end
end
