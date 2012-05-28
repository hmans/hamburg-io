module HamburgIo
  class Application < Freddie::Application
    context do
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

    route do
      context.permissions do |allow|
        allow.index! Event, verified: true
        allow.show! Event

        if context.current_user.present?
          allow.new! Event
          allow.create! Event

          if context.current_user.admin?
            allow.manage! Event
          end
        end
      end

      layout 'application.html.haml'

      path 'assets' do
        layout false
        max_age 1.year

        get 'application-:timestamp.css'  do
          content_type 'text/css'
          render 'application.scss'
        end

        get 'application-:timestamp.js' do
          invoke JavaScriptPacker, :files => 'application.js'
        end
      end

      # omniauth callback
      invoke OmniAuthCallback

      path 'logout' do
        session['user_id'] = nil
        redirect! '/'
      end

      resource Event

      redirect! '/events'
    end
  end
end
