module Freddie
  module Rackable
    extend ActiveSupport::Concern

    def call(env)
      @context = self.class.context_class.from_env(env)

      catch :done do
        serve! route

        # If we get here, #serve decided not to serve.
        raise NotFoundError
      end

      response
    end

    module ClassMethods
      def call(env)
        new.call(env)
      end
    end
  end
end
