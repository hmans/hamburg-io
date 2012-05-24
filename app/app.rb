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

      #invoke :resource, :class => Event
      mount_events

      redirect! '/events'
    end

    def mount_events
      path 'events' do
        get 'new' do
          @event = Event.new
          render 'events/new.html.haml'
        end

        path :id do
          @event = Event.find(params['id'])

          get do
            render 'events/show.html.haml'
          end

          post do
            @event.attributes = params['event']
            if @event.save
              redirect! @event
            else
              render 'events/edit.html.haml'
            end
          end

          get 'edit' do
            render 'events/edit.html.haml'
          end
        end

        post do
          @event = Event.new(params['event'])
          if @event.save
            redirect! @event
          else
            render 'events/new.html.haml'
          end
        end

        get do
          # display all events
          @events = Event.all
          render 'events/index.html.haml'
        end
      end
    end

  end
end
