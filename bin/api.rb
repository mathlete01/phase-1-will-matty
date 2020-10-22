require_relative "../config/environment"
require 'rest-client'
require 'json'
require 'pp'
require 'pry'

def create_congress_members
  if CongressMember.all.length >= 100
    puts "• Politicians DB already seeded"
  else 
    response_string = RestClient.get("https://api.propublica.org/congress/v1/116/senate/members.json", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
    json = JSON.parse(response_string)
    results = json["results"]
    senator_array = json["results"][0]["members"]
    senator_array.each do |senator|
      puts "• Creating #{senator['last_name']}"
      CongressMember.create(name: "#{senator['first_name']} #{senator['last_name']}", party: senator["party"], state: senator["state"], title: senator["short_title"], crp_id: senator["crp_id"], member_id: senator["id"])
    end
  end
end

def create_bills_by_industry(industry_obj)
  response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{industry_obj.name}", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  bills_array = results[0]["bills"]
  bills_array.each do |bill|
    Bill.create(name: bill["short_title"], description: bill["title"], industry_id: industry_obj.id, congress_bill_id: bill["bill_id"])
    #create_vote_for_bill(bill["bill_id"])
    puts "• #{bill["short_title"]}"
  end
end

# def create_vote_for_bill(congress_bill_id)
#   response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{congress_bill_id}", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
#   json = JSON.parse(response_string)
#   results = "vote for bill: #{json["results"]}"
#   #pp results
#   # congress #, bill id, vote
# end

def get_all_votes_by_politician(cm_obj)
  response_string = RestClient.get("https://api.propublica.org/congress/v1/members/#{cm_obj.member_id}/votes.json", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  votes_array = results[0]["votes"]
  votes_array.each do |vote|
    Vote.create(congress_member_id: cm_obj.member_id, bill_id: vote["bill"]["bill_id"], vote: vote["bill"]["position"])
  end
end

def get_random_senator
  rando_senator = CongressMember.all[rand(5)]
  get_all_votes_by_politician(rando_senator.member_id)
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

#get_random_senator

#binding.pry