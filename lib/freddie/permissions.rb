module Freddie
  module Permissions
    module ContextExtensions
      extend ActiveSupport::Concern

      def can?(*args)
        permissions.can?(*args)
      end

      def permissions
        @permissions ||= Permissions.new(self, &self.class.permissions_blk)
      end

      module ClassMethods
        attr_accessor :permissions_blk
      end
    end

    module ApplicationExtensions
      extend ActiveSupport::Concern

      included do
        delegate :can?, :to => :context
      end

      module ClassMethods
        def permissions(&blk)
          context_class.permissions_blk = blk
        end
      end
    end

    class Permissions
      def initialize(context, &blk)
        @context = context
        instance_exec(context, &blk)
      end

      def can?(*args)
        true
      end

      def can(*args)
        puts "cancan!"
      end
    end
  end
end

Freddie::Context.send(:include, Freddie::Permissions::ContextExtensions)
Freddie::Application.send(:include, Freddie::Permissions::ApplicationExtensions)
