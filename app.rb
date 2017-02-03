require "bundler/setup"
Bundler.require(:default)
require "sinatra/reloader"

Dir["models/*.rb"].each do |model|
  require_relative model
end

Dir["repositories/*.rb"].each do |model|
  require_relative model
end

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  configure do
    set :views, settings.root + "/views"
  end

  def self.database_config
    YAML.load_file("config/database.yml")[ENV['RACK_ENV'] || 'development']
  end

  def self.database
    @database ||= Mysql2::Client.new(database_config)
  end

  helpers do
    def entry_repository
      @@entry_repository ||= EntryRepository.new(App.database)
    end

    def tags
      @@tags ||= Tag.new(App.database)
    end

    def title
      str = ""

      if @entry.class == Entry
        str = @entry.title + " - " # rescue params[:name] + " - "
      elsif @entry.class == Array
        str = params[:name] + " - "
      end

      str + "テスト的なブログ"
    end

    def header_title
      "テスト的なブログ"
    end

    def overview
      "テスト的な感じで作ってるブログなはず"
    end

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['username', 'password']
    end
  end

  get "/" do
    slim :index
  end

  get "/entries" do
    slim :entries
  end

  get "/entries/new" do
    # protected!
    slim :new
  end

  get "/entries/delete" do
    slim :delete
  end

  get "/entries/:id" do
    @entry = entry_repository.fetch(params[:id].to_i)

    slim :entry
  end

  get "/tags" do
    slim :tags
  end

  get "/tags/:name" do
    @entry = tags.fetch(params[:name].to_s)

    slim :tag
  end

  post "/delete" do
    type = params[:type]
    action = params[:action]

    url = entry_repository.delete(type, action)
    redirect to(url)
  end

  post "/create" do
    # protected!
    entry = Entry.new
    entry.title = params[:title]
    entry.body = params[:body]

    tags = params[:tags].split(/\R/)
    tags = tags.reject{ |e| e == "" }
    tags.compact
    tags.pop(tags.length - 5) if tags.length > 5
    entry.tags = tags.join(",")

    id = entry_repository.save(entry)

    redirect to("/entries/#{id}")
  end

end
