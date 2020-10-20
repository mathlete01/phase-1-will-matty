require_relative '../config/environment'
require_relative 'api.rb'

issue_array = ["tobacco", "pharmaceuticals", "abortion"]
get_bills_by_issue("tobacco")
binding.pry
0