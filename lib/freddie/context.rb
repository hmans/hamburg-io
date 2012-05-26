require 'freddie/request'
require 'freddie/helpers'

module Freddie
  class Context
    include Helpers

    attr_reader :request, :response, :remaining_path

    def initialize(request, response)
      @request  = request
      @response = response
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout = nil
    end

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
