module HamburgIo
  class Application < Freddie::Application
    include Helpers

    handle_request do
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

      # posting and editing of events
      if admin?
        path 'new_event' do
          get do
            render 'new_event.haml', event: Event.new
          end

          post do
            event = Event.new(params['event'])
            if event.save
              redirect! '/'
            else
              render 'new_event.haml', event: event
            end
          end
        end
      end

      # display all events
      render 'index.haml', events: Event.all
    end

    def current_user
      session['omniauth.user']
    end

    def admin?
      current_user == ['twitter', '645333']
    end
  end
end
