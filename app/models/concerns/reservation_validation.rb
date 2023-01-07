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
  end
end
