
class Api::V1::ReservationsController < Api::V1::BaseApiController

  def index
     render json: { message: "Save " }, status: :ok
  end

  def create
     render json: { message: "Save " }, status: :created
  end

end
