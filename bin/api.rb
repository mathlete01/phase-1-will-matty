require_relative "../config/environment"
require "rest-client"
require "faraday"
require "json"
require "pp"
require "pry"

pro_pub_key = "PUT YOUR PRO PULBICA KEY HERE!!!"
open_secrets_key = "PUT YOUR OPEN SECRETS KEY HERE!!!"

def create_congress_members
  if CongressMember.all.length >= 100
    puts "• Politicians DB already seeded"
  else
    response_string = RestClient.get("https://api.propublica.org/congress/v1/116/senate/members.json", { "X-API-Key" => key })
    json = JSON.parse(response_string)
    results = json["results"]
    senator_array = results[0]["members"]
    senator_array.each do |senator|
      puts "• Creating #{senator["last_name"]}"
      CongressMember.create(name: "#{senator["first_name"]} #{senator["last_name"]}", party: senator["party"], state: senator["state"], title: senator["short_title"], crp_id: senator["crp_id"], member_id: senator["id"])
    end
  end
end

def create_bills_by_industry(industry_obj)
  puts "CALLED: Create Bills By Industry"
  if industry_obj.bills.empty?
    response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{industry_obj.name}", { "X-API-Key" => key })
    json = JSON.parse(response_string)
    results = json["results"]
    #binding.pry
    bills_array = results[0]["bills"]
    bills_array.each do |bill|
      Bill.create(name: bill["short_title"], description: bill["title"], industry: industry_obj, congress_bill_id: bill["bill_id"])
      #create_vote_for_bill(bill["bill_id"])
      #puts "• #{bill["short_title"]}"
    end
  end
end

def get_all_votes_by_politician(cm_obj)
  puts "CALLED: Get All Votes By Politician"
  if cm_obj.votes.empty?
    response_string = RestClient.get("https://api.propublica.org/congress/v1/members/#{cm_obj.member_id}/votes.json", { "X-API-Key" => key })
    json = JSON.parse(response_string)
    results = json["results"]
    #binding.pry
    votes_array = results[0]["votes"]
    votes_array.each do |vote|
      #qbinding.pry
      Vote.create(congress_member: cm_obj, bill_id: vote["bill"]["bill_id"], position: vote["position"])
    end
  end
end

#Get finances and industries from Open secrets
def query_for_finances
  base = "http://www.opensecrets.org/api"
  header = {
    "X-API-Key" => open_secrets_key,
    "Accept" => "application/json",
  }
  CongressMember.all.each do |cm|
    if cm.crp_id
      options = {
        :apikey => open_secrets_key,
        :output => "json",
        :method => "candIndustry",
        :cid => cm.crp_id,
      }
      if cm.donations.size < 10
        response = JSON.parse(Faraday.get(base, options, header).body)
        response["response"]["industries"]["industry"].each do |ind|
          industry_name = ind["@attributes"]["industry_name"]
          total = ind["@attributes"]["total"]
          industry = Industry.find_or_create_by(:name => industry_name)
          Donation.create(congress_member: cm, amount: total, industry: industry)
        end
      end
    end
  end
end

# def create_vote_for_bill(congress_bill_id)
#   response_string = RestClient.get("https://api.propublica.org/congress/v1/bills/search.json?query=#{congress_bill_id}", { "X-API-Key" => key })
#   json = JSON.parse(response_string)
#   results = "vote for bill: #{json["results"]}"
#   #pp results
#   # congress #, bill id, vote
# end
