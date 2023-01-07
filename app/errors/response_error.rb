# frozen_string_literal: true

module ResponseError
  class BadGateway < StandardError; end
  class NotFound < StandardError; end
  class Conflict < StandardError; end
  class InvalidReservationCode < StandardError; end
end
