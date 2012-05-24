require 'niles/utils/date_parameter_converter'

module Freddie
  class Request < Rack::Request
  protected

    def parse_query(qs)
      super(qs).tap do |p|
        Niles::Utils::DateParameterConverter.convert!(p)
      end
    end
  end
end
