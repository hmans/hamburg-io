module HamburgIo
  class Application < Freddie::Application
    helpers do
      def markdown(text)
        @@markdown ||= Redcarpet::Markdown.new(MarkdownRenderer.new(escape_html: true),
          :autolink => true,
          :space_after_headers => true,
          :fenced_code_blocks => true)

        @@markdown.render(text.to_s)
      end

      def current_user
        if session['user_id']
          User.find(session['user_id'])
        end
      end
    end

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
          invoke JavaScriptPacker, :files => 'application.js'
        end
      end

      # omniauth callback
      invoke OmniAuthCallback

      path 'logout' do
        session['user_id'] = nil
        redirect! '/'
      end

      resource Event do
        can :index, -> { where(verified: true) }
        can :show

        if context.current_user.try(:admin?)
          can :manage
        elsif context.current_user.present?
          can :create
        end
      end

      redirect! '/events'
    end
  end
end
