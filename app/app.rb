module HamburgIo
  class Application < Happy::Controller
    include Helpers

    def route
      setup_permissions
      layout 'application.html.haml'

      route_assets
      route_authentication

      resource Event, :role => resource_role

      redirect! '/events'

      # Auch heiter:
      #
      # @events = Happy::Extras::Resources::ResourceMounter.new(self,
      #   :class => Event, :role => resource_role)
      #
      # @events.route
      #
      # redirect! @events.root_url
    end

    def setup_permissions
      can.index! Event, -> e { e.verified.in_the_future }
      can.show! Event

      if current_user.present?
        can.new! Event
        can.create! Event

        if current_user.admin?
          can.manage! Event
          can.index! Event, -> e { e.in_the_future }
        end
      end
    end

    def route_assets
      path? 'favicon.ico', 'images' do
        run Happy::Extras::Static, path: './public'
      end

      path? 'assets' do
        layout false
        max_age 1.year

        get? 'application-:timestamp.css'  do
          content_type 'text/css'
          render 'application.scss'
        end

        get? 'application-:timestamp.js' do
          run JavaScriptPacker, :files => 'application.js'
        end
      end
    end

    def route_authentication
      run OmniAuthCallback

      path? 'logout' do
        session['user_id'] = nil
        redirect! '/'
      end
    end

  end
end
