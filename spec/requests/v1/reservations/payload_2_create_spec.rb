require 'rails_helper'

RSpec.describe "POST /api/v1/reservations/", type: :request  do

  let!(:reservation_code) do
    "XXX12345678"
  end

  let!(:params) do
    {
      reservation: {
        code: reservation_code,
        start_date: "2021-03-12",
        end_date: "2021-03-16",
        expected_payout_amount: "3800.00",
        guest_details: {
          localized_description: "4 guests",
          number_of_adults: 2,
          number_of_children: 2,
          number_of_infants: 0
        },
        guest_email: "wayne_woodbridge@bnb.com",
        guest_first_name: "Wayne",
        guest_last_name: "Woodbridge",
        guest_phone_numbers: [
          "639123456789",
          "639123456789"
        ],
        listing_security_price_accurate: "500.00",
        host_currency: "AUD",
        nights: 4,
        number_of_guests: 4,
        status_type: "accepted",
        total_paid_amount_accurate: "4300.00"
      }
    }
  end

  context 'Create Reservation for Payload 2' do
    it 'successfully created' do
      subject
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:created)
      expect(response.body).to be_json_as({ save: {message: 'Reservation save'} })
    end
  end

  context 'Invalid Payload ' do

    let!(:reservation_code) do
      "INVALID123123123"
    end

    it 'Raise Invalid reservation code' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to be_json_as({ message: 'Reservation Code Not Recognize' })
    end
  end
end
