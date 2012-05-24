module Freddie
  module Helpers
    include Niles::Helpers

    def render(what, options = {}, &blk)
      case what
        when String     then render_template(what, options, &blk)
        when Enumerable then what.map { |i| render(i, options, &blk) }.join
        else render_resource(what, options)
      end
    end

    def render_template(name, variables = {}, &blk)
      Niles::Templates.render(name, self, variables, &blk)
    end

    def render_resource(resource, options = {})
      # build name strings
      singular_name = resource.class.to_s.tableize.singularize
      plural_name   = singular_name.pluralize

      # set options
      options = {
        singular_name => resource
      }.merge(options)

      # render
      render_template("#{plural_name}/_#{singular_name}.html.haml", options)
    end

    alias_method :h, :escape_html
    alias_method :l, :localize
    alias_method :t, :translate
  end
end
