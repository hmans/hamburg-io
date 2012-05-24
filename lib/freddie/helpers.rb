module Freddie
  module Helpers
    include Niles::Helpers

    alias_method :h, :escape_html
    alias_method :l, :localize
    alias_method :t, :translate
  end
end
