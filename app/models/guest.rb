class Guest < ApplicationRecord
  has_many :reservations

  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/.freeze

  validates :email, presence: true
  validates :email, uniqueness: { message: "Email Already Exist" }, format: { with: Guest::EMAIL_REGEX,  message: "Invalid Email Format"}, if: [Proc.new { |c| c.email.present? }]
end
