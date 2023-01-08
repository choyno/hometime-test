class Api::V1::ReservationsController < Api::V1::BaseApiController

  def create
    reservation = ReservationService.new(reservation_params).save_record
    if reservation.errors.present?
      json_response({ error: { message: reservation.errors } }, :unprocessable_entity )
    else
      json_response({ save: { message: 'Reservation save'} }, :created )
    end
  end

  def update
    reservation = ReservationService.new(reservation_params).update_record
    if reservation.errors.present? || reservation.guest.errors.present?
      errors = {reservation: reservation.errors.messages, guest: reservation.guest.errors.messages }
      json_response({ error: { message: errors } }, :unprocessable_entity )
    else
      json_response({ save: { message: 'Reservation updated'} }, :ok )
    end
  end

  private

  def reservation_params
    params.fetch(:reservation, {}).has_key?(:guest_details) ? permit_reservation_second_payload.to_h : permit_reservation_first_payload.to_h
  end

  def permit_reservation_first_payload
    params.permit(
      :reservation_code,
      :start_date,
      :end_date,
      :nights,
      :adults,
      :children,
      :infants,
      :status,
      :currency,
      :payout_price,
      :security_price,
      :total_price,
      :guests,
      guest: [
        :first_name,
        :last_name,
        :phone,
        :email,
      ]
    )
  end

  def permit_reservation_second_payload
    params.require(:reservation).permit(
      :code,
      :start_date,
      :end_date,
      :expected_payout_amount,
      :guest_email,
      :guest_first_name,
      :guest_last_name,
      :listing_security_price_accurate,
      :host_currency,
      :nights,
      :number_of_guests,
      :status_type,
      :total_paid_amount_accurate,
      guest_phone_numbers: [],
      guest_details: [
        :localized_description,
        :number_of_adults,
        :number_of_children,
        :number_of_infants,
      ]
    )
  end
end
