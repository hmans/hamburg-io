module Freddie
  module Rackable
    extend ActiveSupport::Concern

    def call(env)
      @request = Freddie::Request.new(env)
      @response = Rack::Response.new
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout = nil

      catch :done do
        serve! route

        # If we get here, #serve decided not to serve.
        raise NotFoundError
      end

      @response
    end

    module ClassMethods
      def call(env)
        new.call(env)
      end
    end
  end
end
