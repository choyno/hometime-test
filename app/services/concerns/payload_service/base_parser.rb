class PayloadService::BaseParser

  attr_accessor :payload

  def initialize(payload)
    @payload = payload
  end
end