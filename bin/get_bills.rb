require_relative "../config/environment"
require_relative "api.rb"
require_relative "open_secrets_api"

# def create_industries(array)
#   array.each do |element|
#     Industry.create(name: element)
#   end
# end

# def add_all_bills_for_all_industries(array)
#   #binding.pry
#   array.size.times do |i|
#     create_bills_by_industry(array[i]["name"], array[i]["id"])
#   end
# end

def create_bills_by_industry(industry, id)
  response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{industry}", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  bills_array = results[0]["bills"]
  #puts bills_array.length
  bills_array.each do |bill|
    Bill.create(name: bill["short_title"], description: bill["title"], industry_id: id, congress_bill_id: bill["bill_id"])
    #create_vote_for_bill(bill["bill_id"])
    puts "• #{bill["short_title"]}"
  end
end

def create_vote_for_bill(congress_bill_id)
  response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{congress_bill_id}", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = "vote for bill: #{json["results"]}"
  puts results
  # congress #, bill id, vote
end

def get_all_votes_by_politician(crp_id)
  puts "Called!"
  response_string = RestClient.get("https://api.propublica.org/congress/v1/members/#{crp_id}/votes.json", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  puts "json: #{json}"
  puts "Votes: #{results}"
end

def main_switch_board()
  rando_senator = CongressMember.all[rand(5)]
  get_all_votes_by_politician(rando_senator.crp_id)
  puts "-" * 30
  rando_donation = rand(10)
  amount = rando_senator.donations[rando_donation].amount
  industry_id = rando_senator.donations[rando_donation].industry_id
  industry_name = Industry.all[industry_id].name
  puts "#{rando_senator.name} received $#{amount} from the #{industry_name} industry"
  puts "-" * 10
  puts "#{rando_senator.name}'s votes on issues pertaining to the #{industry_name} industry:"
  create_bills_by_industry(industry_name, industry_id)
  puts "-" * 30
end

main_switch_board()