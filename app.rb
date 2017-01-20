require "bundler/setup"
Bundler.require(:default)

class App < Sinatra::Base
  get "/" do
    "Hello World!"
  end
end
