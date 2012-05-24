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

    def resource(klass, options = {})
      invoke :resource_mounter, options.merge(:class => klass)
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

  def resource
    options[:class]
  end

  def set_plural_variable(v)
    instance_variable_set "@#{options[:plural_name]}", v
  end

  def plural_variable
    instance_variable_get "@#{options[:plural_name]}"
  end

  def set_singular_variable(v)
    instance_variable_set "@#{options[:singular_name]}", v
  end

  def singular_variable
    instance_variable_get "@#{options[:singular_name]}"
  end

  def do_index
    set_plural_variable resource.all
    render_resource_template 'index'
  end

  def do_show
    set_singular_variable resource.find(params['id'])
    render_resource_template 'show'
  end

  def do_new
    set_singular_variable resource.new
    render_resource_template 'new'
  end

  def do_create
    set_singular_variable resource.new(params[options[:singular_name]])
    if singular_variable.save
      redirect! singular_variable
    else
      render_resource_template 'new'
    end
  end

  def do_edit
    set_singular_variable resource.find(params['id'])
    render_resource_template 'edit'
  end

  def do_update
    set_singular_variable resource.find(params['id'])
    singular_variable.attributes = params[options[:singular_name]]

    if singular_variable.save
      redirect! singular_variable
    else
      render_resource_template 'edit'
    end
  end

  def handle_request
    @options = {
      singular_name: options[:class].to_s.tableize.singularize,
      plural_name:   options[:class].to_s.tableize.pluralize
    }.merge(@options)

    puts options.inspect
    path options[:plural_name] do
      get('new') { do_new }

      path :id do
        get         { do_show }
        post        { do_update }
        get('edit') { do_edit }
      end

      post { do_create }
      get  { do_index }
    end
  end
end
