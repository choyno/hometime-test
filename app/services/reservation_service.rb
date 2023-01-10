# frozen_string_literal: true

class ReservationService
  attr_accessor :payload

  def initialize(payload)
    @payload = JSON.parse(payload.to_json).deep_symbolize_keys
  end

  def reservation_params
    reservation_parser.except(:guest_attributes)
  end

  def guest_params
    reservation_parser[:guest_attributes]
  end

  def init_reservation
    ReservationService::PayloadParser.new(payload)
  end

  def reservation_parser
    init_reservation.build.attributes
  end

  def reservation_code
    init_reservation.reservation_code
  end

  def save_record
    reservation = Reservation.create(reservation_code: reservation_code)
    reservation.update(reservation_parser)
    return reservation
  end

  def update_record
    reservation = Reservation.find_by(reservation_code: reservation_code)
    reservation.update(reservation_params)
    guest = reservation.guest.update(guest_params)
    return reservation
  end
end
