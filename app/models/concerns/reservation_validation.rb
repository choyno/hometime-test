# frozen_string_literal: true

module ReservationValidation
  extend ActiveSupport::Concern

  included do
    validates :reservation_code, uniqueness: { message: "Reservation is Already Exist" }
    validates :start_date, presence: true
    validates :end_date, presence: true
    validates :nights, presence: true
    validates :guests, presence: true
    validates :adults, presence: true
    validates :children, presence: true
    validates :infants, presence: true
    validates :status, presence: true
    validates :currency, presence: true
    validates :payout_price, presence: true
    validates :security_price, presence: true
    validates :total_price , presence: true
    validates :start_date, date: { before_or_equal_to: :end_date, message: "Must be before or equal to end date" }
    validates :end_date, date: { after_or_equal_to: :start_date, message: "Must be after or equal to start date" }
  end
end
