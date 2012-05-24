module HamburgIo
  module Helpers
    def markdown(text)
      @@markdown ||= Redcarpet::Markdown.new(MarkdownRenderer,
        :autolink => true, :space_after_headers => true, :fenced_code_blocks => true)

      @@markdown.render(text.to_s)
    end

    def current_user
      session['omniauth.user']
    end

    def admin?
      current_user == ['twitter', '645333']
    end
  end
end

Freddie(:javascript_packer) do
  content_type 'text/javascript'

  plain = [options[:files]].flatten.map do |filename|
    File.read("./app/assets/#{filename}")
  end.join("\n")

  Packr.pack(plain)
end

Freddie :omniauth_callback do
  path 'auth' do
    path :provider do
      path 'callback' do
        auth = request.env['omniauth.auth']
        session['omniauth.user'] = [auth['provider'], auth['uid']]
        redirect! '/'
      end
    end
  end
end

Freddie :resource do
end
