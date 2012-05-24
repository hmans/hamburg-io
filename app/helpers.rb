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

class ResourceMounter < Freddie::Application
  def render_resource_template(name)
    render "#{options[:plural_name]}/#{name}.html.haml"
  end

  def do_index
    @events = Event.all
    render_resource_template 'index'
  end

  def do_show
    @event = Event.find(params['id'])
    render_resource_template 'show'
  end

  def do_new
    @event = Event.new
    render_resource_template 'new'
  end

  def do_create
    @event = Event.new(params['event'])
    if @event.save
      redirect! @event
    else
      render_resource_template 'new'
    end
  end

  def do_edit
    @event = Event.find(params['id'])
    render_resource_template 'edit'
  end

  def do_update
    @event = Event.find(params['id'])
    @event.attributes = params['event']

    if @event.save
      redirect! @event
    else
      render 'events/edit.html.haml'
    end
  end

  def handle_request
    @options = {
      singular_name: options[:class].to_s.tableize.singularize,
      plural_name:   options[:class].to_s.tableize.pluralize
    }.merge(@options)

    puts options.inspect
    path options[:plural_name] do
      get 'new' do
        do_new
      end

      path :id do
        get do
          do_show
        end

        post do
          do_update
        end

        get 'edit' do
          do_edit
        end
      end

      post do
        do_create
      end

      get do
        do_index
      end
    end
  end
end
