require 'active_support/all'
require 'freddie/context'
require 'freddie/controller'
require 'freddie/static'

module Freddie
  class FreddieError < StandardError ; end
  class NotFoundError < FreddieError ; end

  def self.env
    ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
  end
end
