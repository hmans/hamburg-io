class JavaScriptPacker < Freddie::Application
  route do
    content_type 'text/javascript'

    plain = [options[:files]].flatten.map do |filename|
      File.read("./app/assets/#{filename}")
    end.join("\n")

    Packr.pack(plain)
  end
end

class OmniAuthCallback < Freddie::Application
  route do
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

class ResourceMounter < Freddie::Application
  INDEX_PERMISSIONS   = [:index, :view, :manage]
  SHOW_PERMISSIONS    = [:show, :view, :manage]
  NEW_PERMISSIONS     = [:new, :create, :manage]
  CREATE_PERMISSIONS  = [:create, :manage]
  EDIT_PERMISSIONS    = [:edit, :update, :manage]
  UPDATE_PERMISSIONS  = [:update, :manage]
  DESTROY_PERMISSIONS = [:destroy, :manage]

  def render_resource_template(name)
    render "#{options[:plural_name]}/#{name}.html.haml"
  end

  def permissions
    @permissions ||= {}
  end

  def can(*args)
    scope = args.pop if args.last.is_a?(Hash) || args.last.is_a?(Proc)

    args.each do |what|
      permissions[what.to_sym] = scope || true
    end
  end

  def can?(*whats)
    find_permission(*whats).present?
  end

  def find_permission(*whats)
    whats.flatten.each do |what|
      if p = permissions[what.to_sym]
        return p
      end
    end
    nil
  end

  def resource
    options[:class]
  end

  def resource_with_permission_scope(*whats)
    if p = find_permission(*whats)
      r = resource

      if p.is_a?(Hash)
        r = r.where(p[:where])
      elsif p.is_a?(Proc)
        r = r.instance_exec(&p)
      end

      r
    else
      resource.where(false)
    end
  end

  def require_permission!(*args)
    raise "not allowed" unless can?(*args)
  end

  def set_plural_variable(v)
    context.instance_variable_set "@#{options[:plural_name]}", v
  end

  def plural_variable
    context.instance_variable_get "@#{options[:plural_name]}"
  end

  def set_singular_variable(v)
    context.instance_variable_set "@#{options[:singular_name]}", v
  end

  def singular_variable
    context.instance_variable_get "@#{options[:singular_name]}"
  end

  def do_index
    require_permission! INDEX_PERMISSIONS
    set_plural_variable resource_with_permission_scope(INDEX_PERMISSIONS).all
    render_resource_template 'index'
  end

  def do_show
    require_permission! SHOW_PERMISSIONS
    set_singular_variable resource_with_permission_scope(SHOW_PERMISSIONS).find(params['id'])
    render_resource_template 'show'
  end

  def do_new
    require_permission! NEW_PERMISSIONS
    set_singular_variable resource_with_permission_scope(NEW_PERMISSIONS).new
    render_resource_template 'new'
  end

  def do_create
    require_permission! CREATE_PERMISSIONS
    set_singular_variable resource_with_permission_scope(CREATE_PERMISSIONS).new(params[options[:singular_name]])

    if singular_variable.save
      redirect! singular_variable
    else
      render_resource_template 'new'
    end
  end

  def do_edit
    require_permission! EDIT_PERMISSIONS
    set_singular_variable resource_with_permission_scope(EDIT_PERMISSIONS).find(params['id'])
    render_resource_template 'edit'
  end

  def do_update
    require_permission! UPDATE_PERMISSIONS
    set_singular_variable resource_with_permission_scope(UPDATE_PERMISSIONS).find(params['id'])
    singular_variable.attributes = params[options[:singular_name]]

    if singular_variable.save
      redirect! singular_variable
    else
      render_resource_template 'edit'
    end
  end

  def route
    @options = {
      singular_name: options[:class].to_s.tableize.singularize,
      plural_name:   options[:class].to_s.tableize.pluralize
    }.merge(@options)

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
