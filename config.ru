require './config/boot'

# We're using cookies, so let's load a cookies middleware.
#
use Rack::Session::Cookie

# Enable Rack::Cache in production.
#
use Rack::Cache if Happy.env.production?

# Enable live code reloading in devleopment. Note that this will not reload
# config.ru or boot.rb.
#
use Rack::Reloader, 0 if Happy.env.development?

# Configure the OmniAuth middleware.
#
use OmniAuth::Builder do
  unless Happy.env.production?
    provider :developer, fields: [:email], uid_field: :email
  end

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

# That's it. Let's run the application!
#
run HamburgIo::Application
