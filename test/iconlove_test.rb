require 'iconlove'
require 'test/unit'
require 'sinatra/test'

set :environment, :test

class IconLoveTest < Test::Unit::TestCase

  include Sinatra::Test

  def test_index_page
    get '/'
    assert response.ok?
  end

end

