class PayloadService::PayloadTwoParser < PayloadService::BaseParser

  def attributes
    {
      guest_attributes: {
        first_name: payload[:guest_first_name],
        last_name: payload[:guest_last_name],
        phone_numbers: payload[:guest_phone_numbers],
        email: payload[:guest_email],
      },
      reservation_code: payload[:code],
      start_date: payload[:start_date],
      end_date: payload[:end_date],
      nights: payload[:nights],
      guests: payload[:number_of_guests],
      adults: payload[:guest_details][:number_of_adults],
      children: payload[:guest_details][:number_of_children],
      infants: payload[:guest_details][:number_of_infants],
      status: payload[:status_type],
      localized_description: payload[:guest_details][:localized_description],
      currency: payload[:host_currency],
      payout_price: payload[:expected_payout_amount],
      security_price: payload[:listing_security_price_accurate],
      total_price: payload[:total_paid_amount_accurate]
    }
  end

  def current_payload?
    payload.key?(:code) && payload[:code].include?("XXX")
  end
end
