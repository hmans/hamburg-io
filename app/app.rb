require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'freddie'

class JavascriptPacker < Freddie::Handler
  def invoke
    content_type 'text/javascript'

    plain = [options[:files]].flatten.map do |filename|
      File.read("./app/assets/#{filename}")
    end.join("\n")

    Packr.pack(plain)
  end
end

class HamburgIoApp < Freddie::Application
  def handle_request
    layout 'application.html.haml'

    path 'assets' do
      layout false

      get 'application-:timestamp.css'  do
        content_type 'text/css'
        layout false
        render 'application.scss'
      end

      get 'application-:timestamp.js' do
        invoke JavascriptPacker, :files => 'application.js'
      end
    end

    render('index.haml')
  end

  def current_user
    'hmans'
  end
end
