require './config/boot'

# new relic!
if Happy.env.development?
  require 'new_relic/rack/developer_mode'
  use NewRelic::Rack::DeveloperMode
end

# cookies!
use Rack::Session::Cookie

# cache!
use Rack::Cache if Happy.env.production?

# code reloading
use Rack::Reloader, 0 if Happy.env.development?

# omniauth!
use OmniAuth::Builder do
  unless Happy.env.production?
    provider :developer, fields: [:email], uid_field: :email
  end

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

# run the hamburg.io app
run HamburgIo::Application
