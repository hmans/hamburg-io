source :rubygems

if ENV['DEV']
  gem 'happy', path: '../happy'
  gem 'happy-helpers', path: '../happy-helpers'
  gem 'allowance', path: '../allowance'
else
  gem 'happy', github: 'hmans/happy'
  gem 'happy-helpers', github: 'hmans/happy-helpers'
  gem 'allowance', github: 'hmans/allowance'
end

# application
gem 'sass'
gem 'haml'
gem 'thin'
gem 'unicorn'
gem 'schnitzelstyle', github: 'hmans/schnitzelstyle'
# gem 'compass'
gem 'packr'
gem 'redcarpet'
gem 'rack-cache', require: 'rack/cache'
gem 'awesome_print'

# for heroku/monitoring
gem 'newrelic_rpm'

# for models
gem "mongoid", "~> 2.4"
gem "bson_ext", "~> 1.5"

# for rake console
gem "rake"
gem "pry"

# for authentication
gem 'omniauth'
gem 'omniauth-twitter'

group :development do
  gem 'debugger'
end

