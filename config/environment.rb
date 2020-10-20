require "bundler/setup"
require "sinatra/activerecord"
Bundler.require
require_all "lib"
require_all "app/models"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "db/development.db")
