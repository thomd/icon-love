require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'
ENV['GEM_HOME'] = "#{ENV['HOME']}/.gems"
require 'rubygems'
Gem.clear_paths

disable :run
set :raise_errors, true
set :environment, :production
set :app_file, 'koguma.rb'

log = File.new("log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

require 'koguma'
run Sinatra::Application
