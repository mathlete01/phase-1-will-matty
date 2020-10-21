class Bill < ActiveRecord::Base
  has_many :votes
  has_many :congress_members, through: :votes
  belongs_to :industry
end
