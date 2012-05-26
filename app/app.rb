module HamburgIo
  class Context < Freddie::Context
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

    delegate :can?, to: :app
  end

  class Application < Freddie::Application
    use_context HamburgIo::Context

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
        if context.current_user.try(:admin?)
          can :manage
        else
          can :index, -> { where(verified: true) }
          can :create
        end
      end

      redirect! '/events'
    end

    def resource(klass, options = {}, &blk)
      invoke ResourceMounter, options.merge(:class => klass), &blk
    end
  end
end
