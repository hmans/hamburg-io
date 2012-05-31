$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '../app'))

require 'rubygems'
require 'bundler/setup'
Bundler.require

# framework
require 'happy'
require 'happy/permissions'
require 'happy/resources'

# setup i18n
I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../config/locales', '*.yml').to_s]
I18n.locale = 'de'

Mongoid::Config.from_hash(
  'uri' => ENV['MONGOLAB_URI'] || ENV['MONGOHQ_URL'] || ENV['MONGO_URL'] || 'mongodb://localhost/eventually'
)

class MarkdownRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
end

# my own code
require 'models'
require 'helpers'
require 'app'
