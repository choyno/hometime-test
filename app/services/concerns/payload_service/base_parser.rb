class PayloadService::BaseParser

  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end

  def reservation_code
    attributes[:reservation_code]
  end

  def reservation_details
    attributes.except(:guest_attributes)
  end

  def guest_details
    attributes[:guest_attributes]
  end

  def call
    if current_payload?
      return self
    else
      return nil
    end
  end
end
