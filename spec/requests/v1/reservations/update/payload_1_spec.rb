require 'rails_helper'

RSpec.describe "PUT /api/v1/reservations/", type: :request  do

  let!(:guest) { create(:guest, email: guest_params[:guest][:email]) }
  let!(:reservation) { create(:reservation, guest: guest, reservation_code: reservation_code) }

  let!(:reservation_code) do
    "YYY12345678"
  end

  let!(:email) do
    "wayne_woodbridge@bnb.com"
  end

  let!(:reservation_params) do
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
      currency: "AUD",
      payout_price: "4200.00",
      security_price: "500",
      total_price: "4700.00"
    }
  end

  let!(:guest_params) do
    {
      guest: {
        first_name: "Wayne",
        last_name: "Woodbridge",
        phone: "639123456789",
        email: email
      },
    }
  end

  let!(:params) do
    {
      reservation_code: reservation_code,
      start_date: "2021-04-1",
      end_date: "2021-04-5",
      nights: 1,
      guests: 1,
      adults: 1,
      children: 1,
      infants: 1,
      status: "accepted",
      guest: {
        first_name: "Wayne",
        last_name: "Woodbridge",
        phone: "639123456789",
        email: email
      },
      currency: "AUD",
      payout_price: "4200.00",
      security_price: "500",
      total_price: "4700.00"
    }
  end

  context 'Update Reservation for Payload 1' do

    it 'successfully updated' do
      put api_v1_reservations_path params: params
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:ok)
      expect(response.body).to be_json_as({ save: {message: 'Reservation updated'} })
    end
  end

end
