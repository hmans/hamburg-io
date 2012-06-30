# Let Bundler do its thing.
#
require 'rubygems'
require 'bundler/setup'
Bundler.require

# Load dependencies from Happy.
#
require 'happy'
require 'happy/extras/static'

# Load NewRelic in production.
#
if Happy.env.production?
  require 'newrelic_rpm'
  NewRelic::Agent.manual_start
  Happy::Controller.extend NewRelic::Agent::Instrumentation::Rack
end

# Setup I18n.
#
I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../config/locales', '*.yml').to_s]
I18n.locale = 'de'

# Tell Mongoid where to connect to.
#
Mongoid::Config.from_hash(
  'uri' => ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGO_URL'] || 'mongodb://localhost/eventually'
)

# A little MarkdownRenderer class for Redcarpet.
#
class MarkdownRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
end

# Load the files contained in the 'app' directory
#
Dir['./app/*.rb'].each { |name| require name }
Dir['./app/**/*.rb'].each { |name| require name }
