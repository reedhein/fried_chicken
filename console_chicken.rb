require 'boxr'
require 'uri'
require 'pry'
require_relative 'lib/fried_chicken'
require '../global_utilities/global_utilities'

class ConsoleChicken
  attr_reader :client, :user
  def initialize
    ENV['BOX_CLIENT_ID']     = CredService.creds.box.client_id
    ENV['BOX_CLIENT_SECRET'] = CredService.creds.box.client_secret
    @user = User.first
    token_refesh_callback = lambda do |access, refresh, identifier| 
      puts "Access: #{access}\n"
      puts "refresh: #{refresh}\n"
      puts "identifier: #{identifier}\n"
      user.box_access_token  = access
      user.box_refresh_toekn = refresh
      user.box_identifier    = identifier
      user.save
    end
    token = @user.access_token || CredService.creds.box.token
    @client = Boxr::Client.new(token, 
                                refresh_token: user.box_refresh_token,
                                &token_refesh_callback
                              )
  end

end

chicken = ConsoleChicken.new

binding.pry
chicken.client

