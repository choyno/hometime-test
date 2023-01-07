class ApplicationController < ActionController::API
  include Response
  include ApiErrorHandler

  rescue_from Exception do |e|
     json_response({ message: 'There was a problem. Please try again later.' }, :internal_server_error)
  end
end
