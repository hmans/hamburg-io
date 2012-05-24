require 'active_support/all'

require 'freddie/application'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end
end
