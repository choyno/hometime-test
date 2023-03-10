require 'rails_helper'

RSpec.describe "POST /api/v1/reservations/", type: :request  do

  let(:reservation_code) do
    "YYY12345678"
  end

  let(:email) do
    "wayne_woodbridge@bnb.com"
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
        email: email
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
      expect(response.body).to be_json_as({ save: {message: 'Reservation save'} })
    end

    it 'save correct guest details' do
      subject
      guest = Guest.last
      expect(guest.email).to eq(params[:guest][:email])
      expect(guest.first_name).to eq(params[:guest][:first_name])
      expect(guest.last_name).to eq(params[:guest][:last_name])
      expect(guest.phone_numbers).to eq(params[:guest][:phone].split)
    end

    it 'save correct reservation details' do
      subject
      guest = Guest.last
      reservation = guest.reservations.last
      expect(reservation.reservation_code).to eq(params[:reservation_code])
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
      expect(reservation.total_price.to_f).to eq(params[:total_price].to_f)
    end
  end


  context 'Validated Guest Exist' do

    let(:guest) { create(:guest, email: params[:guest][:email]) }

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

  context 'Validated Guest Email Format' do

    let!(:email) do
      "invalid"
    end

    it 'Invalid Email' do
      subject
      expect(Guest.all.count).to eq(0)
      expect(Reservation.all.count).to eq(0)
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to be_json_as({
        error: {
          message: {
            "guest.email": [
              "Invalid Email Format"
            ]
          }
        }
      })
    end
  end

  context 'Validated Reservation Validation' do

    let!(:params) do
      {
        reservation_code: reservation_code,
        start_date: "",
        end_date: "",
        nights: nil,
        guests: nil,
        adults: nil,
        children: nil,
        infants: nil,
        status: ,
        guest: {
          first_name: "Wayne",
          last_name: "Woodbridge",
          phone: "639123456789",
          email: nil
        },
        currency: nil,
        payout_price: nil,
        security_price: nil,
        total_price: nil
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
               "can't be blank",
             ]
          }
        }
      })
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
