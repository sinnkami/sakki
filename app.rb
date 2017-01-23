require "bundler/setup"
Bundler.require(:default)
require "sinatra/reloader"

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  configure do
    set :views, settings.root + "/views"
  end

  get "/" do
    slim :index
  end

  get "/entries/new" do
    slim :new
  end

  get "/entries/:id" do

  end

  post "/entries" do
    entry = Entry.new
    entry.title = params[:title]
    entry.body = params[:body]

    id = entry_repository.save(entry)

    redirect to("/entries/#{id}")
  end

end
