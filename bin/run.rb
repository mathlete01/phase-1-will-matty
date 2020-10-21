require_relative "../config/environment"
require_relative "api.rb"
require_relative "./cli.rb"

#Create an instance of the CLI
cli = CLI.new
#Launch the CLI menu
cli.menu

#binding.pry
0
