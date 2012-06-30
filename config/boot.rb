$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../app'))

require 'rubygems'
require 'bundler/setup'
Bundler.require

# framework
require 'happy'
require 'happy/extras/static'

# new relic
require 'newrelic_rpm'
NewRelic::Agent.manual_start
Happy::Controller.extend NewRelic::Agent::Instrumentation::Rack

# setup i18n
I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../config/locales', '*.yml').to_s]
I18n.locale = 'de'

Mongoid::Config.from_hash(
  'uri' => ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGO_URL'] || 'mongodb://localhost/eventually'
)

class MarkdownRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
end

# Compass has some really nice Sass mixins, and I would like to use them outside
# of Rails (or Sinatra) without having to configure Compass through a configuration file
# or framework-level configuration. From Sass' perspective, it's simply a matter of
# adding the path containing Compass' Sass stylesheets to the Sass engine's
# load path, so let's do that until there's a smoother way.
#
# Sass::Engine::DEFAULT_OPTIONS[:load_paths] << Compass::Frameworks["compass"].stylesheets_directory

# my own code
require 'models'
require 'helpers'
require 'app'
