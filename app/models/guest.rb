class Guest < ApplicationRecord
  has_many :reservations

  validates :email, presence: true
  validates :email, uniqueness: { message: "Email Already Exist" }
end
