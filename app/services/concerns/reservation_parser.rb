class ReservationParser

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
      raise_invalid_resercation_code
    end
  end

  def call

    if reservation_code.include?("YYY") #payload 1
      {
        first_name: payload[:guest][:first_name],
        last_name: payload[:guest][:last_name],
        phone_numbers: payload[:guest][:phone].split,
        email: payload[:guest][:email],
        reservations_attributes: [{
          reservation_code: payload[:reservation_code],
          start_date: payload[:start_date],
          end_date: payload[:end_date],
          nights: payload[:nights],
          guests: payload[:guests],
          adults: payload[:adults],
          children: payload[:children],
          infants: payload[:infants],
          status: payload[:status],
          currency: payload[:currency],
          payout_price: payload[:payout_price],
          security_price: payload[:security_price],
          total_price: payload[:total_price]
        }]
      }
    elsif reservation_code.include?("XXX") #payload 2
      {
        first_name: payload[:guest_first_name],
        last_name: payload[:guest_last_name],
        phone_numbers: payload[:guest_phone_numbers][0],
        email: payload[:guest_email],
        reservations_attributes: [{
          reservation_code: payload[:code],
          start_date: payload[:start_date],
          end_date: payload[:end_date],
          nights: payload[:nights],
          guests: payload[:number_of_guests],
          adults: payload[:guest_details][:number_of_adults],
          children: payload[:guest_details][:number_of_children],
          infants: payload[:guest_details][:number_of_infants],
          status: payload[:status_type],
          localized_description: payload[:localized_description],
          currency: payload[:host_currency],
          payout_price: payload[:expected_payout_amount],
          security_price: payload[:listing_security_price_accurate],
          total_price: payload[:total_paid_amount_accurate]
        }]
      }
    else
      raise_invalid_resercation_code
    end
  end

  def raise_invalid_resercation_code
    raise ResponseError::InvalidReservationCode, "Reservation Code Not Recognize"
  end
end
