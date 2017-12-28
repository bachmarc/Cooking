# encoding: utf-8
require 'sinatra/base'
require 'yaml'
require 'digest/md5'
require 'sequel'
require 'mysql2'
require 'sinatra/sequel'


class App < Sinatra::Base
  

  # Include Session Cookie Module
  use Rack::Session::Cookie, :secret => "iuiouiog7frz6ztde45ea65i576t786p76g78678f6786r78p6f78ocsewtuüuihux"
  

  # Production specific configs
  configure :production do
    YAML.load_file(File.dirname(__FILE__)+'/config/production.yaml').each do |k, v|
      set k, v
    end    
  end

  # General ENV configuration
  configure do

    dbconf = YAML.load_file(File.dirname(__FILE__)+'/config/database.yaml')

    case dbconf["adapter"]
      when "mysql"
        dbconf = dbconf[ENV['RACK_ENV']]
                 DB = Sequel.connect("mysql2://#{dbconf["username"]}:#{dbconf["password"]}@#{dbconf["host"]}:#{dbconf["port"]}/#{dbconf["database"]}")
      when "sqlite3"
        #DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/application.db")
    end    

    # Enable sessions for all ENV's
    enable :sessions    
    
    # Set up our general configs
    set :root          , File.dirname(__FILE__)
    set :public_folder , File.dirname(__FILE__) + '/public'
    set :app_file      , __FILE__
    set :views         , File.dirname(__FILE__) + '/views'
    set :dump_errors   , true
    set :logging       , true
    set :raise_errors  , true
  end

  # Load general development configs from the file
  configure :development do
      YAML.load_file(File.dirname(__FILE__)+'/config/development.yaml').each do |k, v|
      set k, v
    end    
  end
  

  # Log error and redirect
  error do
     redirect to('500.html')
  end

  # Redirect to static 404 page
  not_found do
      redirect to('404.html')
  end  
end

# Load up all helpers first (NB)
Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each do |file| 
  require file
end

# Load up all models next
Dir[File.dirname(__FILE__) + "/models/*.rb"].each do |file| 
  require file
end


# Load up all controllers last
Dir[File.dirname(__FILE__) + "/controllers/*.rb"].each do |file| 
  require file
end