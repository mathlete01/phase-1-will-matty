require "faraday"
require "json"
require "pry"

def query_for_finances
  base = "http://www.opensecrets.org/api"
  key = "40dca1f69a36b95c944aad4672acbc2b"
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
