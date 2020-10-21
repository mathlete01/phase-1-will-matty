class Industry < ActiveRecord::Base
  has_many :bills
  has_many :donations
  has_many :congress_members, through: :donations
end
