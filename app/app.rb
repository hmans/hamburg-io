module HamburgIo
  Happy.context do
    def asset_timestamp
      (ENV['ASSET_TIMESTAMP'] ||= Time.now.to_i.to_s).to_i
    end

    def markdown(text)
      @@markdown ||= Redcarpet::Markdown.new(MarkdownRenderer.new(escape_html: true),
        :autolink => true,
        :space_after_headers => true,
        :fenced_code_blocks => true)

      @@markdown.render(text.to_s)
    end

    def current_user
      @current_user ||= if session['user_id']
        User.find(session['user_id'])
      end
    end
  end

  class Controller < Happy::Controller
    def setup_permissions
      can.index! Event, -> e { e.verified.in_the_future }
      can.show! Event

      if context.current_user.present?
        can.new! Event
        can.create! Event

        if context.current_user.admin?
          can.manage! Event
          can.index! Event, -> e { e.in_the_future }
        end
      end
    end

    def route
      setup_permissions

      layout 'application.html.haml'

      path 'favicon.ico', 'images' do
        run Happy::Extensions::Static, path: './public'
      end

      path 'assets' do
        layout false
        max_age 1.year

        get 'application-:timestamp.css'  do
          content_type 'text/css'
          render 'application.scss'
        end

        get 'application-:timestamp.js' do
          run JavaScriptPacker, :files => 'application.js'
        end
      end

      # omniauth callback
      run OmniAuthCallback

      path 'logout' do
        session['user_id'] = nil
        redirect! '/'
      end

      (c = Happy::Extensions::Resources::ResourceMounter.new(env,
        :class => Event,
        :role => resource_role)
      ).perform

      redirect! c.root_url
    end

    def resource_role
      context.current_user.try(:admin?) ? :admin : nil
    end
  end
end
