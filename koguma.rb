require 'rubygems'
require 'sinatra'
require 'haml'
require 'sass'
require 'dm-core'
require 'hpricot'
require 'uri'
require 'open-uri'
require 'activesupport'


class Url
  
  attr_accessor :url, :icon_url, :data
  
  def initialize(url)  
    @url = url
  end
  
  def invalid?
    pattern = /(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
    !pattern.match(@url)
  end
  
  def webroot_url
    @icon_url = URI.parse(@url) + "/favicon.ico"
  end
  
  def linkrel_url
    page = Hpricot(open(@url))
    @icon_url = page.at("//link[@rel='shortcut icon']").attributes["href"]
  end
  
  def save_icon
    @data = ActiveSupport::Base64.encode64s(open(@icon_url).read)
    Favicon.create(:url => @url, :favicon_url => @icon_url, :data => @data, :created_on => Time.now)
  end
  
  def get_icon
    @data
  end
  
end


# ----- model -----------------------------------------------------------------

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/favicon.sqlite3")

class Favicon
  include DataMapper::Resource
  property :id,             Serial
  property :url,            String
  property :favicon_url,    String
  property :data,           Text
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
  @favicons = Favicon.all(:order => [:created_on.asc])
  haml :index
end

get '/new' do
  haml :new
end

post '/' do
  @url = Url.new(params[:url])
  error 400, haml("This is not a valid URL") if @url.invalid?
  
  @url.webroot_url
  @url.save_icon
  
  haml "<img src=\"data:image/vnd.microsoft.icon;base64,#{@url.get_icon}\" />"
end

get '/bookmarklet' do
  haml :bookmarklet
end

get '/:stylesheet.css' do
  headers 'Content-Type' => 'text/css; charset=utf-8'
  sass params[:stylesheet].to_sym
end

