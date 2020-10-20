class CongressMember < ActiveRecord::Base
  has_many :votes
  has_many :donations
  has_many :bills, through: :votes
end
