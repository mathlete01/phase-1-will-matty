require 'rest-client'
require 'json'
require 'pp'
require 'pry'

def create_industries(array)
  array.each do |element|
    Industry.create(name: element)
  end
end

def add_all_bills_for_all_industries(array)
  #binding.pry
  array.size.times do |i|
    create_bills_by_industry(array[i]["name"], array[i]["id"])
  end
end

def create_bills_by_industry(industry, id)
  response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{industry}", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  bills_array = results[0]["bills"]
  #puts bills_array.length
  bills_array.each do |bill|
    Bill.create(name: bill["short_title"], description: bill["title"], industry_id: id, congress_bill_id: bill["bill_id"])
  end
  #start
end

def create_congress_members
  response_string = RestClient.get("https://api.propublica.org/congress/v1/116/senate/members.json", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  senator_array = json["results"][0]["members"]
  senator_array.each do |senator|
    CongressMember.create(name: "#{senator['first_name']} #{senator['last_name']}", party: senator["party"], state: senator["state"], title: senator["short_title"], crp_id: senator["crp_id"])
  end
end