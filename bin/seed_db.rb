require_relative "../config/environment"
require_relative "api.rb"
require_relative "open_secrets_api"

create_congress_members
query_for_finances
