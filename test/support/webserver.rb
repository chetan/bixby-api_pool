
require 'sinatra/base'

class TestApp < Sinatra::Base

  get "/boot" do
    "booted"
  end

  get "/" do
    "get"
  end

  get "/echo/:str" do
    "echo #{params[:str]}"
  end

  post "/" do
    "post"
  end

  post "/json" do
    b = MultiJson.load(body)
    b["foo"]
  end

end
