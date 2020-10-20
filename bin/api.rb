require 'rest-client'
require 'json'
require 'pp'
require 'pry'

def get_bills_by_issue(issue)
  #binding.pry
  response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{issue}", { "X-API-Key" => 'VjRSqQm09s5VuHJUcSFHHk2I33KcrmWnqbTCExQB' })
  json = JSON.parse(response_string)
  results = json["results"]
  bills_array = results[0]["bills"]
  bills_array.each do |bill|
    Bill.create(name: bill["short_title"], description: bill["title"])
  end
end