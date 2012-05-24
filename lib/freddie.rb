require 'active_support/all'

require 'freddie/application'
require 'active_support/inflector'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end
end

def Freddie(name, &blk)
  klass = Class.new(Freddie::Application)
  klass.handle_request &blk
  Object.const_set(name.to_s.classify, klass)
end
