module Freddie
  class Static < Freddie::Controller
    def route
      run Rack::File.new(options[:path])
    end
  end
end
