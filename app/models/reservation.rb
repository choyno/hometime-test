class Reservation < ApplicationRecord
  include ReservationValidation

  belongs_to :guest
  accepts_nested_attributes_for :guest

  def has_errors?
    self.errors.present? || self.guest.errors.present?
  end
end
