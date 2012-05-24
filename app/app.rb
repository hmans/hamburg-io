require_relative "../config/boot"

require 'helpers'

module HamburgIo
  class Application < Freddie::Application
    include Helpers

    handle_request do
      layout 'application.html.haml'

      path 'assets' do
        layout false

        get 'application-:timestamp.css'  do
          content_type 'text/css'
          layout false
          render 'application.scss'
        end

        get 'application-:timestamp.js' do
          invoke :javascript_packer, :files => 'application.js'
        end
      end

      # display all events
      @events = Event.all
      render 'index.haml'
    end

    def current_user
      'hmans'
    end
  end
end
