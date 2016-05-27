require 'rubygems'
require 'sinatra'
require 'watir'
require 'haml'
require 'boxr'
require 'asciiart'
require 'yaml'
require 'pry'
a = AsciiArt.new([Dir.pwd, 'assets', 'fried_chicken.jpg'].join('/'))
puts a.to_ascii_art(color: true, width: 95)
$cnf = YAML::load(File.open('secrets.yml'))
class BoxSalesWeb < Sinatra::Base
  set env: :development
  set port: 4567
  set bind: '0.0.0.0'
  use Rack::Session::Pool

  get '/' do
    haml :index
  end
  
  get '/authenticate' do 
    form_component = URI.encode_www_form_component($cnf.dig('box', 'client_id'))
    oauth_url = Boxr::oauth_url(client_id: form_component)

    agent = Watir::Browser.new :firefox
    begin
      agent.goto(oauth_url.to_s)
    
      token_refresh_callback = lambda { |access, referesh, identifier| puts "refreshing" }
      client = Boxr::Client.new('tSdeuMwPH67jy0GJTYHjHADeDcxN1KbM',
        refresh_token: $cnf.dig('box', 'refresh_token'),
        client_id: $cnf.dig('box', 'client_id'),
        client_secret: $cnf.dig('box', 'client_secret'),
        &token_refresh_callback
      )
      puts client
      binding.pry
    ensure
      agent.close
    end
  end

  post '/auth/box/callback' do
    binding.pry
  end

  `say fried chicken is coming online` if RbConfig::CONFIG['host_os'] =~ /darwin/
  run! if app_file == $0
end
