require 'boxr'
require 'uri'
require 'pry'
require '../global_utilities/global_utilities'
require_relative 'lib/fried_chicken'

ENV['BOX_CLIENT_ID']     = CredService.creds.box.client_id
ENV['BOX_CLIENT_SECRET'] = CredService.creds.box.client_secret
class ConsoleChicken

  attr_reader :client, :user, :sf_client, :box_client

  def initialize
    @user       = User.first
    @box_client = FriedChicken::BoxClient.new(@user)
    @sf_client  = GlobalUtilities::SalesForce::Client.new(@user)
  end

end

chicken = ConsoleChicken.new

class BoxrMash
  def client
    @client ||= ConsoleChicken.new.box_client
  end

  def details
    client.folder(self)
  end

  def folders
    client.folder_items(self).select do |entry|
      entry.type == 'folder'
    end
  end

  def items
    client.folder_items(self)
  end

  def files
    client.folder_items(self).select do |entry|
      entry.type == 'file'
    end
  end

  def create_folder(name)
    client.create_folder(name , self) #returns details of folder
  end

  def path
    paths = get_details(:path_collection).entries.map do |entry|
      entry.name
    end
    ["", paths, self.name].join('/')
  end
  private

  def get_details(attribute)
    self.send(attribute) || self.details.send(attribute)
  end
  
end

c = chicken.box_client
folders = c.root_folder_items
folders[1].folders.first.path
files = folders[1].files
binding.pry
puts 'end of doc' # need this for pry-byebug

