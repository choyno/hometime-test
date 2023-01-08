require 'rails_helper'

RSpec.describe "POST /api/v1/reservations/", type: :request  do

  let(:reservation_code) do
    "XXX12345678"
  end

  let(:email) do
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

  context 'Create Reservation for Payload 2' do
    it 'successfully created' do
      subject
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:created)
      expect(response.body).to be_json_as({ save: {message: 'Reservation save'} })
    end

    it 'save correct guest details' do
      subject
      guest = Guest.last
      reserve_params = params[:reservation]
      expect(guest.email).to eq(reserve_params[:guest_email])
      expect(guest.first_name).to eq(reserve_params[:guest_first_name])
      expect(guest.last_name).to eq(reserve_params[:guest_last_name])
      expect(guest.phone_numbers).to eq(reserve_params[:guest_phone_numbers])
    end

    it 'save correct reservation details' do
      subject
      guest = Guest.last
      reservation = guest.reservations.last
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
    end
  end

  context 'Validated Guest Exist' do

    let(:guest) { create(:guest, email: params[:reservation][:guest_email]) }

    before do
      create(:reservation, guest: guest)
    end

    it 'validation Email already exist' do
      post '/api/v1/reservations', params: params 
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to be_json_as({
        error: {
          message: {
            "guest.email": [
              "Email Already Exist"
            ]
          }
        }
      })
    end
  end

  context 'Validated Reservation Exist' do

    let!(:email) { "another@email.com"  }

    before do
      create(:reservation, reservation_code: reservation_code)
    end

    it 'validation Email already exist' do
      subject
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to be_json_as({
        error: {
          message: {
            reservation_code: [
              "Reservation is Already Exist"
            ],
          }
        }
      })
    end
  end

  context 'Validated Reservation Exist and Email Exist' do

    let(:email) { "another@email.com"  }
    let(:guest) { create(:guest, email: email) }

    before do
      create(:reservation, reservation_code: reservation_code, guest: guest)
    end

    it 'validation Reservation and Email already exist' do
      subject
      expect(Guest.all.count).to eq(1)
      expect(Reservation.all.count).to eq(1)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to be_json_as({
        error: {
          message: {
            reservation_code: [
              "Reservation is Already Exist"
            ],
            "guest.email": [
              "Email Already Exist"
            ]
          }
        }
      })
    end
  end

  context 'Validated Reservation Validation' do

    let!(:params) do
      {
        reservation: {
          code: reservation_code,
          start_date: nil,
          end_date: nil,
          expected_payout_amount: nil,
          guest_details: {
            localized_description: "4 guests",
            number_of_adults: nil,
            number_of_children: nil,
            number_of_infants: nil
          },
          guest_email: nil,
          guest_first_name: "Wayne",
          guest_last_name: "Woodbridge",
          guest_phone_numbers: [
            "639123456789",
            "639123456789"
          ],
          listing_security_price_accurate: nil,
          host_currency: nil,
          nights: nil,
          number_of_guests: nil,
          status_type: nil,
          total_paid_amount_accurate: nil
        }
      }
    end

    it 'show validation required fields' do
      subject
      expect(Guest.all.count).to eq(0)
      expect(Reservation.all.count).to eq(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to be_json_as({
        error: {
          message: {
            start_date: [
              "can't be blank",
              "Must be before or equal to end date"
            ],
            end_date: [
              "can't be blank",
               "Must be after or equal to start date"
            ],
            nights: [
              "can't be blank"
            ],
            "guests": [
              "can't be blank"
            ],
            "adults": [
              "can't be blank"
            ],
            "children": [
              "can't be blank"
            ],
            "infants": [
              "can't be blank"
            ],
            "status": [
              "can't be blank"
            ],
            "currency": [
              "can't be blank"
            ],
            "payout_price": [
              "can't be blank"
            ],
            "security_price": [
              "can't be blank"
            ],
            "total_price": [
              "can't be blank"
            ],
            "guest.email": [
              "can't be blank"
            ]
          }
        }
      })
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
end
