require "bundler/setup"
Bundler.require(:default)

class App < Sinatra::Base
  configure do
    set :views, settings.root + "/views"
  end

  get "/" do
    slim :index
  end
end
