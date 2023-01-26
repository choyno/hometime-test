class PayloadService::PayloadOneParser < PayloadService::BaseParser
  def attributes
    {
      guest_attributes: {
        first_name: payload[:guest][:first_name],
        last_name: payload[:guest][:last_name],
        phone_numbers: payload[:guest][:phone].split,
        email: payload[:guest][:email],
      },
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
    }
  end
end
