require "faraday"
require "json"
require "pry"

#Get infos
def query_for_finances
  base = "http://www.opensecrets.org/api"
  key = "53b8248b9eacc45c011fca9185cf6957" # Will's
  #key = "7e27e1f20d4c696e6374ae2d45e3a033" # Matty's
  header = {
    "X-API-Key" => key,
    "Accept" => "application/json",
  }
  CongressMember.all.each do |cm|
    if cm.crp_id
      options = {
        :apikey => key,
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
