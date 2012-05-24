module Freddie
  module Routing
    def path_to_regexp(path)
      path = ":#{path}" if path.is_a?(Symbol)
      Regexp.compile('^'+path.gsub(/\)/, ')?').gsub(/\//, '\/').gsub(/\./, '\.').gsub(/:(\w+)/, '(?<\\1>.+)')+'$')
    end

    def path(name = nil, options = {})
      if name.present?
        path_match = path_to_regexp(name).match(remaining_path.first)
      end

      method_matched = [nil, request.request_method.downcase.to_sym].include?(options[:method])
      path_matched   = (path_match || (name.nil? && remaining_path.empty?))

      # Only do something here if method and requested path both match
      if path_matched && method_matched
        # Transfer variables contained in path name to params hash
        if path_match
          path_match.names.each { |k| request.params[k] = path_match[k] }
          remaining_path.shift
        end

        serve! yield

        # If we get here, #serve decided not to serve.
        raise NotFoundError
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
  end
end
