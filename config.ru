require './config/boot'

use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

run HamburgIo::Application
