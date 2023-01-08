require 'rails_helper'

RSpec.describe "PUT /api/v1/reservations/", type: :request  do

  let!(:guest) { create(:guest, email: email) }
  let!(:reservation) { create(:reservation, guest: guest, reservation_code: reservation_code) }

  let!(:reservation_code) do
    "XXX12345678"
  end

  let!(:email) do
    "wayne_woodbridge@bnb.com"
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
        guest_email: email,
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

  context 'Update Reservation for Payload 2' do

    let(:old_reservation) { reservation }

    it 'successfully updated' do

      put api_v1_reservations_path params: params

      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)

      reservation = Reservation.last
      reserve_params = params[:reservation]

      expect(reservation.reservation_code).to eq(reserve_params[:code])
      expect(reservation.start_date.strftime("%Y-%m-%d")).to eq(reserve_params[:start_date])
      expect(reservation.end_date.strftime("%Y-%m-%d")).to eq(reserve_params[:end_date])
      expect(reservation.nights).to eq(reserve_params[:nights])
      expect(reservation.guests).to eq(reserve_params[:number_of_guests])
      expect(reservation.adults).to eq(reserve_params[:guest_details][:number_of_adults])
      expect(reservation.children).to eq(reserve_params[:guest_details][:number_of_children])
      expect(reservation.infants).to eq(reserve_params[:guest_details][:number_of_infants])
      expect(reservation.localized_description).to eq(reserve_params[:guest_details][:localized_description])
      expect(reservation.currency).to eq(reserve_params[:host_currency])
      expect(reservation.security_price.to_f).to eq(reserve_params[:listing_security_price_accurate].to_f)
      expect(reservation.total_price.to_f).to eq(reserve_params[:total_paid_amount_accurate].to_f)

      expect(response).to have_http_status(:ok)
      expect(response.body).to be_json_as({ save: {message: 'Reservation updated'} })
    end
  end
end
