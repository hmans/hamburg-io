require 'freddie/request'
require 'freddie/helpers'

module Freddie
  class Context
    include Helpers

    attr_reader   :request, :response, :remaining_path
    attr_accessor :layout, :app

    def initialize(request, response)
      @request  = request
      @response = response
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout   = nil
      @app      = nil
    end

  private

    def params
      request.params
    end

    def session
      request.session
    end

    class << self
      def from_env(env)
        new(Freddie::Request.new(env), Rack::Response.new)
      end
    end
  end
end
