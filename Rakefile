ENV["SINATRA_ENV"] ||= "development"
require "active_record"
require_relative "config/environment"
require "sinatra/activerecord/rake"

task :environment do
  ENV["ACTIVE_RECORD_ENV"] ||= "development"
  require_relative "./config/environment"
end

desc "starts a console"
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
