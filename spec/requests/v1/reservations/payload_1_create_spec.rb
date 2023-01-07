require 'rails_helper'

RSpec.describe "POST /api/v1/reservations/", type: :request  do

  let!(:reservation_code) do
    "YYY12345678"
  end

  let!(:params) do
    {
      reservation_code: reservation_code,
      start_date: "2021-04-14",
      end_date: "2021-04-18",
      nights: 4,
      guests: 4,
      adults: 2,
      children: 2,
      infants: 0,
      status: "accepted",
      guest: {
        first_name: "Wayne",
        last_name: "Woodbridge",
        phone: "639123456789",
        email: "wayne_woodbridge@bnb.com"
      },
      currency: "AUD",
      payout_price: "4200.00",
      security_price: "500",
      total_price: "4700.00"
    }
  end

  context 'Create Reservation for Payload 1' do
    it 'successfully created' do
      subject
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:created)
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
