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

Freddie :resource_mounter do
  path 'events' do
    get 'new' do
      @event = Event.new
      render 'events/new.html.haml'
    end

    path :id do
      @event = Event.find(params['id'])

      get do
        render 'events/show.html.haml'
      end

      post do
        @event.attributes = params['event']
        if @event.save
          redirect! @event
        else
          render 'events/edit.html.haml'
        end
      end

      get 'edit' do
        render 'events/edit.html.haml'
      end
    end

    post do
      @event = Event.new(params['event'])
      if @event.save
        redirect! @event
      else
        render 'events/new.html.haml'
      end
    end

    get do
      # display all events
      @events = Event.all
      render 'events/index.html.haml'
    end
  end
end
