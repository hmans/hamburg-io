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
  end
end
