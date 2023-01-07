# frozen_string_literal: true

module ResponseError
  class BadGateway < StandardError; end
  class NotFound < StandardError; end
  class Conflict < StandardError; end
end
