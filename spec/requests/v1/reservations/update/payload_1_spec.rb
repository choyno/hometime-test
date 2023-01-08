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
      start_date: "2021-04-01",
      end_date: "2021-04-05",
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

    let(:old_reservation) { reservation }

    it 'successfully updated' do

      put api_v1_reservations_path params: params

      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)

      reservation = Reservation.last

      expect(old_reservation.to_json).not_to eq(reservation.to_json)
      expect(reservation.start_date.strftime("%Y-%m-%d")).to eq(params[:start_date])
      expect(reservation.end_date.strftime("%Y-%m-%d")).to eq(params[:end_date])
      expect(reservation.nights).to eq(params[:nights])
      expect(reservation.guests).to eq(params[:guests])
      expect(reservation.adults).to eq(params[:adults])
      expect(reservation.children).to eq(params[:children])
      expect(reservation.infants).to eq(params[:infants])
      expect(reservation.currency).to eq(params[:currency])
      expect(reservation.payout_price.to_f).to eq(params[:payout_price].to_f)
      expect(reservation.security_price.to_f).to eq(params[:security_price].to_f)
      expect(response).to have_http_status(:ok)
      expect(response.body).to be_json_as({ save: {message: 'Reservation updated'} })
    end
  end
end
