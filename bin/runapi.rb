require_relative '../config/environment'
require_relative 'api.rb'

issue_array = ["tobacco", "pharmaceuticals", "abortion"]
create_bills_by_issue("tobacco")

create_congress_members