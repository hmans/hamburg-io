module Freddie
  class Context
    attr_reader :request, :response

    def initialize(request, response)
      @request  = request
      @response = response
    end
  end
end
