require_relative '../config/environment'
require_relative 'api.rb'

# industry_array = ["tobacco", "pharmaceuticals", "climate", "oil", "healthcare"]

industry_array = ["Retired", "Health Professionals", "Education", "Lawyers/Law Firms", "Hospitals / Nursing Homes", "Securities & Investment", "Electronics MFG & Equip", "Public Sector Unions", "Misc Finance"]

create_industries(industry_array)
add_all_bills_for_all_industries(Industry.all)
create_congress_members

# def start
#   puts "Enter an industry"
#   input = gets.chomp.downcase
#   create_bills_by_industry(input)
# end

#start

