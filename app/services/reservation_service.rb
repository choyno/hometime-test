# frozen_string_literal: true

class ReservationService
  attr_accessor :payload

  def initialize(payload)
    @payload = create_hash(payload)
  end

  def reservation_params
    ReservationParser.new(payload).call
  end

  def reservation_code
    ReservationParser.new(payload).reservation_code
  end

  def call
    guest = Reservation.find_or_create_by(reservation_code: reservation_code)
    guest.update(reservation_params)
    return guest
  end

  private

  def create_hash(string_or_hash)
    if string_or_hash.is_a?(String)
      Hash[string_or_hash.split(',').map {|str| str.split('=>')}]
    elsif string_or_hash.is_a?(Hash)
      string_or_hash
    end
  end
end
