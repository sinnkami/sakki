require "bundler/setup"
Bundler.require(:default)

app = Proc.new do |env|
  [200, { 'Content-Type' => 'text/plain'}, ['Hello World!']]
end

Rack::Handler::WEBrick.run app
