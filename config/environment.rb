require "bundler/setup"
require "sinatra/activerecord"
require "colorize"
Bundler.require
require_all "lib"
require_all "app/models"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/development.db")
#Include line below to turn off logger
ActiveRecord::Base.logger = nil
