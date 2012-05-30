require 'freddie/request'
require 'freddie/helpers'

module Freddie
  class Context
    include Helpers

    attr_reader   :request, :response, :remaining_path
    attr_accessor :layout, :controller
    delegate      :params, :session, :to => :request

    def initialize(request, response)
      @request    = request
      @response   = response
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }
      @layout     = nil
      @controller = nil
    end

    def with_controller(new_controller)
      # remember previous controller
      old_controller = self.controller
      self.controller = new_controller

      # execute permissions block
      controller.class.permissions_blk.try(:call, permissions, self)

      # execute block
      yield
    ensure
      # switch back to previous controller
      self.controller = old_controller
    end

  private

    class << self
      def from_env(env)
        new(Freddie::Request.new(env), Rack::Response.new)
      end
    end
  end
end
