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

      # omniauth callback
      invoke :omniauth_callback

      # display all events
      render 'index.haml', events: Event.all
    end

    def current_user
      session['omniauth.user']
    end
  end
end
