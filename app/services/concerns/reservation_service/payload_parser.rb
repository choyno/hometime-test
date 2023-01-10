class ReservationService::PayloadParser

  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def build
    case
    when payload_1 = PayloadService::PayloadOneParser.new(payload).call then payload_1
    when payload_2 = PayloadService::PayloadTwoParser.new(payload).call then payload_2
    else
      raise_invalid_reservation_code
    end
  end

  def raise_invalid_reservation_code
    raise ResponseError::InvalidReservationCode, "Reservation Code Not Recognize"
  end
end
