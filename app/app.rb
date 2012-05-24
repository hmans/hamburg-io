require 'rubygems'
require 'bundler/setup'
Bundler.require

require 'freddie'

class HamburgIoApp < Freddie::Application
  def handle_request
    path 'foo' do
      get  { 'GETting bar' }
      post { 'POSTing bar' }
    end

    path 'user' do
      "The current user is: #{current_user}"
    end

    path 'hello' do
      path :name do
        "Hello, #{params['name']}!"
      end

      "Please specify a name."
    end

    render('index.haml')
  end

  def current_user
    'hmans'
  end
end
