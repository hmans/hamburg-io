require './config/boot'

use Rack::Session::Cookie

use Rack::Cache if Freddie.env.production?

#use Rack::Static, :urls => ["/images"], :root => "public"

use OmniAuth::Builder do
  unless Freddie.env.production?
    provider :developer, fields: [:email], uid_field: :email
  end

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

run HamburgIo::Controller
