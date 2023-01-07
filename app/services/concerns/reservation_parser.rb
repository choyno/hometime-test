class ReservationParser

  class InvalidReservationCode < StandardError; end

  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def reservation_code
    payload.fetch(:reservation_code) || payload.fetch(:reservation, {}).fetch(:code)
  end

  def call

    raise InvalidReservationCode if reservation_code.nil?

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
        first_name: payload[:reservation][:guest_first_name],
        last_name: payload[:reservation][:guest_last_name],
        phone_numbers: payload[:reservation][:guest_phone_numbers][0],
        email: payload[:reservation][:guest_email],
        reservations_attributes: [{
          reservation_code: payload[:reservation][:code],
          start_date: payload[:reservation][:start_date],
          end_date: payload[:reservation][:end_date],
          nights: payload[:reservation][:nights],
          guests: payload[:reservation][:number_of_guests],
          adults: payload[:reservation][:guest_details][:number_of_adults],
          children: payload[:reservation][:guest_details][:number_of_children],
          infants: payload[reservation][:guest_details][:number_of_infants],
          status: payload[:reservation][status_type],
          currency: payload[:reservation][:host_currency],
          payout_price: payload[:reservation][:expected_payout_amount],
          security_price: payload[:reservation][:listing_security_price_accurate],
          total_price: payload[:reservation][:total_paid_amount_accurate]
        }]
      }
    else
      raise InvalidReservationCode
    end
  end
end
