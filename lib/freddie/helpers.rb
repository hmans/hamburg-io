module Freddie
  module Helpers
    include Niles::Helpers

    def render(what, options = {}, &blk)
      case what
        when String then Niles::Templates.render(what, self, options, &blk)
      end
    end

    alias_method :h, :escape_html
    alias_method :l, :localize
    alias_method :t, :translate
  end
end
