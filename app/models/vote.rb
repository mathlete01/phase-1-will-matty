class Vote < ActiveRecord::Base
  belongs_to :congress_member
  belongs_to :bill
end
