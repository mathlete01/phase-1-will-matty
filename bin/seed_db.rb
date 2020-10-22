require_relative "../config/environment"
require_relative "api.rb"
require_relative "open_secrets_api"

#industry_array = ["Retired", "Health Professionals", "Education", "Lawyers/Law Firms", "Hospitals / Nursing Homes", "Securities & Investment", "Electronics MFG & Equip", "Public Sector Unions", "Misc Finance"]

#create_industries(industry_array)
#add_all_bills_for_all_industries(Industry.all)
create_congress_members
query_for_finances
