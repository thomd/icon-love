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

get '/koguma.css' do
  content_type 'text/css'
  sass :beauty
end

use_in_file_templates!
__END__

@@index
!!! Strict
%html
  %head
    %meta{'http-equiv' => "Content-Type", :content => "text/html; charset=utf-8"}
    %link{:rel => 'stylesheet', :href => '/koguma.css', :type => 'text/css'}
    %title= "favicon love"
  %body
    %h1= "favicon love"

@@koguma
*
  :margin 0
  :padding 0
body
  :font-family Helvetica Neue, Helvetica, Arial, sans-serif
