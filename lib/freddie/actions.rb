module Freddie
  module Actions
    def serve!(data, options = {})
      return unless remaining_path.empty?
      return unless data.is_a?(String)

      # mix in default options
      options = {
        layout: @layout
      }.merge(options)

      # add optional headers et al
      @response.status = options[:status] if options.has_key?(:status)
      @response['Content-type'] = options[:content_type] if options.has_key?(:content_type)

      # apply layout
      if options[:layout]
        data = render(options[:layout]) { data }
      end

      # set response body and finish request
      @response.body = [data]
      halt!
    end

    def halt!(message = :done)
      throw message
    end

    def render(what, options = {}, &blk)
      case what
        when String then Niles::Templates.render(what, self, &blk)
      end
    end

    def layout(name)
      @layout = name
    end

    def content_type(type)
      header 'Content-type', type
    end

    def header(name, value)
      response[name] = value
    end

    def invoke(klass, options = {})
      klass = klass.to_s.classify.constantize if klass.is_a?(Symbol)
      klass.new(self, options).handle_request
    end
  end
end
