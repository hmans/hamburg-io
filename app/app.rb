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
      session['omniauth.user']
    end

    def admin?
      current_user == ['twitter', '645333']
    end
  end

  class Application < Freddie::Application
    #include Helpers

    # Use our own context class
    use_context HamburgIo::Context

    # Route requests
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
        session['omniauth.user'] = nil
        redirect! '/'
      end

      resource Event

      redirect! '/events'
    end

    def resource(klass, options = {})
      invoke ResourceMounter, options.merge(:class => klass)
    end
  end
end
