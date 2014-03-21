
require 'sinatra/base'

class TestApp < Sinatra::Base

  get "/" do
    return "get"
  end

  post "/" do
    return "post"
  end

  post "/json" do
    b = MultiJson.load(body)
    return b["foo"]
  end

end
