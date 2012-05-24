require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'freddie'

class HamburgIoApp < Freddie::Application
  def handle_request
    get('application-:timestamp.css') { serve! render('application.scss'), content_type: 'text/css' }
    get('application-:timestamp.js')  { serve! File.read('views/application.js'), content_type: 'text/javascript' }
    render('index.haml')
  end

  def current_user
    'hmans'
  end
end
