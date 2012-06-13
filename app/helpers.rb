JavaScriptPacker = Happy.route do
  content_type 'text/javascript'

  plain = [options[:files]].flatten.map do |filename|
    File.read("./app/assets/#{filename}")
  end.join("\n")

  Packr.pack(plain)
end

OmniAuthCallback = Happy.route do
  path? 'auth' do
    path? :provider do
      path? 'callback' do
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
