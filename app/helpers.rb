module HamburgIo
  module Helpers

    def asset_timestamp
      ENV['ASSET_TIMESTAMP'] ||= Time.now.to_i.to_s
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

    def resource_role
      current_user.try(:admin?) ? :admin : nil
    end

    class JavaScriptPacker < Happy::Controller
      def route
        content_type 'text/javascript'

        plain = [options[:files]].flatten.map do |filename|
          File.read("./app/assets/#{filename}")
        end.join("\n")

        Packr.pack(plain)
      end
    end

    class OmniAuthCallback < Happy::Controller
      def route
        path 'auth' do
          path :provider do
            path 'callback' do
              auth = request.env['omniauth.auth']

              user = User.find_or_initialize_by :identity => [auth['provider'], auth['uid']]
              user.name = auth['info']['nickname'] || auth['info']['name']
              user.save!

              session['user_id'] = user.id
              redirect! '/'
            end
          end
        end
      end
    end

  end
end
