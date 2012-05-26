require 'freddie/routing'
require 'freddie/actions'
require 'freddie/rackable'

module Freddie
  class Application
    include Routing
    include Actions
    include Rackable

    attr_reader :options, :context

    delegate :request, :response, :remaining_path, :params, :session,
      :render, :url_for,
      :to => :context

    def initialize(context = nil, options = {})
      @context = context
      @options = options
    end

    def route
      instance_exec(&self.class.route_blk) if self.class.route_blk
    end

    class << self
      attr_reader :route_blk

      def route(&blk)
        @route_blk = blk
      end

      def context(klass)
        @context_class = klass
      end

      def context_class
        @context_class || Freddie::Context
      end
    end
  end
end
