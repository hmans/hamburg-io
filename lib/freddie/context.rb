require 'freddie/request'
require 'freddie/helpers'

module Freddie
  class Context
    include Helpers

    attr_reader   :request, :response, :remaining_path
    attr_accessor :layout, :app
    delegate      :params, :session, :to => :request

    def initialize(request, response)
      @request  = request
      @response = response
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout   = nil
      @app      = nil
    end

    def with_app(new_app)
      # remember previous app
      old_app = self.app
      self.app = new_app

      # execute permissions block
      app.class.permissions_blk.call(permissions, self) if app.class.permissions_blk

      # execute block
      yield
    ensure
      # switch back to previous app
      self.app = old_app
    end

  private

    class << self
      def from_env(env)
        new(Freddie::Request.new(env), Rack::Response.new)
      end
    end
  end
end
