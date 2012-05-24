module Freddie
  module Actions
    def serve!(data, options = {})
      # Pass to delegate app if present.
      @delegate_app.serve!(data, options) if @delegate_app

      # Don't serve if there are still bits of path
      # remaining.
      return unless remaining_path.empty?

      # Don't serve is data is not a string.
      return unless data.is_a?(String)

      # Mix in default options
      options = {
        layout: @layout
      }.merge(options)

      # Add optional headers et al
      @response.status = options[:status] if options.has_key?(:status)
      @response['Content-type'] = options[:content_type] if options.has_key?(:content_type)

      # Apply layout, if available
      if options[:layout]
        data = render(options[:layout]) { data }
      end

      # Set response body and finish request
      @response.body = [data]
      halt!
    end

    def halt!(message = :done)
      throw message
    end

    def redirect!(to, status = 302)
      header "Location", url_for(to)
      response.status = status
      halt!
    end

    def layout(name)
      @layout = name
    end

    def content_type(type)
      header 'Content-type', type
    end

    def max_age(t, options = {})
      options = {
        :public => true,
        :must_revalidate => true
      }.merge(options)

      s = []
      s << 'public' if options[:public]
      s << 'must-revalidate' if options[:must_revalidate]
      s << "max-age=#{t.to_i}"

      cache_control s.join(', ')
    end

    def cache_control(s)
      header 'Cache-control', s
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
