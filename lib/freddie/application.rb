require 'freddie/routing'
require 'freddie/actions'
require 'freddie/rackable'

module Freddie
  class Application
    include Routing
    include Actions
    include Rackable

    attr_reader :options, :env

    delegate :request, :response, :remaining_path, :params, :session,
      :render, :url_for,
      :to => :context

    def initialize(env = nil, options = {}, &blk)
      @env = env
      @options = options
      instance_exec(&blk) if blk
    end

    def perform
      context.with_app(self) do
        route
      end
    end

  private

    def context
      @env['freddie.context'] ||= self.class.context_class.from_env(@env)
    end

    def route
      instance_exec(&self.class.route_blk) if self.class.route_blk
    end

    class << self
      attr_reader :route_blk

      def route(&blk)
        @route_blk = blk
      end

      def context(&blk)
        context_class.class_exec(&blk)
      end

      def context_class
        Freddie::Context
      end
    end
  end
end
