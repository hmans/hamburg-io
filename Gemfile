source :rubygems

# for freddie
gem 'rack'
gem 'activesupport'

if ENV['DEV']
  gem 'niles', path: '../niles'
  gem 'allowance', path: '../allowance'
else
  gem 'niles', github: 'hmans/niles'
  gem 'allowance', github: 'hmans/allowance'
end

# application
gem 'haml'
gem 'thin'
gem 'unicorn'
gem 'schnitzelstyle', github: 'hmans/schnitzelstyle'
gem 'packr'
gem 'redcarpet'
gem 'rack-cache', require: 'rack/cache'
gem 'awesome_print'

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

