require 'rails_helper'

RSpec.describe "POST /api/v1/reservations/", type: :request  do

  it 'successfully create payload 1' do
    subject
    expect(response).to have_http_status(:created)
  end
end
