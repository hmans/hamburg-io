module HamburgIo
  class OmniAuthCallback < Happy::Controller
    def route
      on 'auth' do
        on :provider do
          on 'callback' do
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
