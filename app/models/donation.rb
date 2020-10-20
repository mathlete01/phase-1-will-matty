class Donation < ActiveRecord::Base
    belongs_to :congress_member
    belongs_to :issues
end
