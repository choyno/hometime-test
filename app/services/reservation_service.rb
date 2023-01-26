# frozen_string_literal: true

class ReservationService
  attr_accessor :payload

  def initialize(payload)
    @payload = JSON.parse(payload.to_json).deep_symbolize_keys
  end

  def reservation_parser
    init_parser = ReservationService::PayloadParser.new(payload)
    init_parser.build
  end

  def save_record
    reservation = Reservation.create(reservation_code: reservation_parser.reservation_code)
    reservation.update(reservation_parser.attributes)
    return reservation
  end

  def update_record
    reservation = Reservation.find_by(reservation_code: reservation_parser.reservation_code)
    reservation.update(reservation_parser.reservation_details)
    guest = reservation.guest.update(reservation_parser.guest_details)
    return reservation
  end
end
