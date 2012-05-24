require './config/boot'

use Rack::Session::Cookie
use OmniAuth::Builder do
  unless Freddie.env.production?
    provider :developer, fields: [:email], uid_field: :email
  end

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

run HamburgIo::Application
