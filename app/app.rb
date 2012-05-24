require_relative "../config/boot"

Freddie(:javascript_packer) do
  content_type 'text/javascript'

  plain = [options[:files]].flatten.map do |filename|
    File.read("./app/assets/#{filename}")
  end.join("\n")

  Packr.pack(plain)
end

class HamburgIoApp < Freddie::Application
  handle_request do
    layout 'application.html.haml'

    path 'assets' do
      layout false

      get 'application-:timestamp.css'  do
        content_type 'text/css'
        layout false
        render 'application.scss'
      end

      get 'application-:timestamp.js' do
        invoke :javascript_packer, :files => 'application.js'
      end
    end

    # display all events
    @events = Event.all
    render 'index.haml'
  end

  def markdown(text)
    @@markdown ||= Redcarpet::Markdown.new(MarkdownRenderer,
      :autolink => true, :space_after_headers => true, :fenced_code_blocks => true)

    @@markdown.render(text.to_s)
  end

  def current_user
    'hmans'
  end
end
