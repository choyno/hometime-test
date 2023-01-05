require 'rails_helper'

RSpec.describe "GET /api/v1/reservations/", type: :request  do

  it 'successfully create payload 1' do
    #get api_v1_reservations_path
    subject
    expect(response).to have_http_status(:success)
  end
end
