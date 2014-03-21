
require 'sinatra/base'

class TestApp < Sinatra::Base

  get "/" do
    return "hi"
  end

end
