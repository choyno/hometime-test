# frozen_string_literal: true

class ReservationService
  attr_accessor :payload

  def initialize(payload)
    @payload = JSON.parse(payload.to_json).deep_symbolize_keys
  end

  def reservation_params
    ReservationParser.new(payload).call
  end

  def reservation_code
    ReservationParser.new(payload).reservation_code
  end

  def save_record
    guest = Reservation.create(reservation_code: reservation_code)
    guest.update(reservation_params)
    return guest
  end
end
