module Freddie
  module Permissions
    module ContextExtensions
      extend ActiveSupport::Concern

      def permissions(&blk)
        @permissions ||= Allowance.define(&blk)
      end

      def can?(*args)
        permissions.allowed?(*args)
      end
    end

    module ApplicationExtensions
      extend ActiveSupport::Concern

      included do
        delegate :can?, :to => :context
      end
    end
  end
end

Freddie::Context.send(:include, Freddie::Permissions::ContextExtensions)
Freddie::Application.send(:include, Freddie::Permissions::ApplicationExtensions)
