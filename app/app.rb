require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'freddie'

class HamburgIoApp < Freddie::Application
  def handle_request
    path 'foo' do
      get  { serve! 'GET bar' }
      post { serve! 'POST bar' }
    end

    path 'user' do
      serve! "The current user is: #{current_user}"
    end

    serve! 'home page'
  end

  def current_user
    'hmans'
  end
end
