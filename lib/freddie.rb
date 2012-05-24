require 'active_support/all'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end

  class Application
    attr_reader :request, :response, :remaining_path

    def call(env)
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @remaining_path = @request.path.split('/').reject {|s| s.blank? }

      catch :done do
        handle_request
        raise NotFoundError
      end

      @response
    end

    def handle_request
      # implement this in a subclass
    end

    def serve!(what, options = {})
      # only serve if no path is remainng
      return unless remaining_path.empty?

      # add optional headers et al
      @response.status = options[:status] if options.has_key?(:status)
      @response['Content-type'] = options[:content_type] if options.has_key?(:content_type)

      # set response body and finish request
      @response.body = [what]
      halt!
    end

    def halt!(message = :done)
      throw message
    end

    def path_to_regexp(path)
      path = ":#{path}" if path.is_a?(Symbol)
      Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(?<\\1>.+)')+'$')
    end

    def path(name = nil, options = {})
      if name.present?
        path_match = path_to_regexp(name).match(remaining_path.first)
      end

      method_match = [nil, request.request_method.downcase.to_sym].include?(options[:method])

      # Only do something here if method and requested path both match
      if (name.nil? || path_match) && method_match
        # Transfer variables contained in path name to params hash
        if path_match
          path_match.names.each { |k| request.params[k] = path_match[k] }
        end

        p = remaining_path.shift
        yield
        remaining_path.unshift(p)
      end
    end

    def get(name = nil, options = {}, &blk)
      path(name, options.merge(method: :get), &blk)
    end

    def post(name = nil, options = {}, &blk)
      path(name, options.merge(method: :post), &blk)
    end

    def put(name = nil, options = {}, &blk)
      path(name, options.merge(method: :put), &blk)
    end

    def delete(name = nil, options = {}, &blk)
      path(name, options.merge(method: :delete), &blk)
    end


    class << self
      def call(env)
        new.call(env)
      end
    end
  end
end
