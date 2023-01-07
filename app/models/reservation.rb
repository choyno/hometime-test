class Reservation < ApplicationRecord
  belongs_to :guest
  accepts_nested_attributes_for :guest

  validates :reservation_code, uniqueness: { message: "Reservation is Already Exist" }
  validates :start_date, :end_date, presence: true
end
