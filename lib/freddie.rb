require 'active_support/all'

require 'freddie/application'
require 'active_support'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end

  def self.env
    ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
  end
end

def Freddie(name, &blk)
  klass = Class.new(Freddie::Application)
  klass.handle_request &blk
  Object.const_set(name.to_s.classify, klass)
end
