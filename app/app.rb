module HamburgIo
  class Application < Freddie::Application
    include Helpers

    route do
      layout 'application.html.haml'

      path 'assets' do
        layout false
        max_age 1.year

        get 'application-:timestamp.css'  do
          content_type 'text/css'
          render 'application.scss'
        end

        get 'application-:timestamp.js' do
          invoke :javascript_packer, :files => 'application.js'
        end
      end

      # omniauth callback
      invoke :omniauth_callback

      path 'logout' do
        session['omniauth.user'] = nil
        redirect! '/'
      end

      resource Event

      redirect! '/events'
    end
  end
end
