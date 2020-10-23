require_relative "../config/environment"
require_relative "api.rb"
require_relative "open_secrets_api"

# Set up initial local database for the app
create_congress_members
query_for_finances
