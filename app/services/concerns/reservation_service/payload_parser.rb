class ReservationService::PayloadParser

  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def reservation_code
    if payload.key?(:reservation_code)
      payload.fetch(:reservation_code)
    elsif payload.key?(:code)
      payload.fetch(:code)
    else
      nil
    end
  end

  def build
    raise_invalid_reservation_code if reservation_code.nil?
    case
    when reservation_code.include?("YYY") then PayloadService::PayloadOneParser.new(payload)
    when reservation_code.include?("XXX") then PayloadService::PayloadTwoParser.new(payload)
    else
      raise_invalid_reservation_code
    end
  end

  def raise_invalid_reservation_code
    raise ResponseError::InvalidReservationCode, "Reservation Code Not Recognize"
  end
end
