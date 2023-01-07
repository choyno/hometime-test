# frozen_string_literal: true

class ReservationService
  attr_accessor :payload

  def initialize(payload)
    @payload = create_hash(payload)
  end

  def reservation_params
    ReservationParser.call(payload)
  end

  def call
    guest = Guest.find_or_create_by(email: reservation_params[:email])
    guest.update(reservation_params)
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
