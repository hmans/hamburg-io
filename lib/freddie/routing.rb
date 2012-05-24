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
  end
end
