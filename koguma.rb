require 'rubygems'
require 'sinatra'
require 'haml'
require 'dm-core'


# ----- model -----------------------------------------------------------------

DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/favicon.sqlite3"))

class Favicon
  include DataMapper::Resource
  property :id,             Serial
  property :url,            String
  property :data,           String
  property :created_on,     DateTime
end

DataMapper.auto_upgrade!



# ----- sinatra ---------------------------------------------------------------

configure do
  set :sass, :style => :expanded
end


helpers do
end


get '/' do
  haml :index
end

get '/new' do
  haml :new
end

get '/bookmarklet' do
  haml :bookmarklet
end

get '/:stylesheet.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass params[:stylesheet].to_sym
end

