require 'rails_helper'

RSpec.describe 'Devices API', type: :request do
  before(:each) do
    Device.clear_all
  end

  let(:device_id) { '36d5658a-6908-479e-887e-a949ec199272' }

  let(:valid_readings) do
    {
      readings: [
        { timestamp: '2021-09-29T16:08:15+01:00', count: 2 },
        { timestamp: '2021-09-29T16:09:15+01:00', count: 15 }
      ]
    }
  end

  let(:duplicate_readings) do
    {
      readings: [
        { timestamp: '2021-09-29T16:08:15+01:00', count: 2 },  # Original
        { timestamp: '2021-09-29T16:08:15+01:00', count: 10 }  # Duplicate
      ]
    }
  end

  # POST /devices/:id/readings - valid readings
  it 'stores valid readings' do
    post "/devices/#{device_id}/readings", params: valid_readings

    expect(response).to have_http_status(:ok)

    # Fetch the cumulative count
    get "/devices/#{device_id}/cumulative_count"
    json_response = JSON.parse(response.body)
    expect(json_response['cumulative_count']).to eq(17)

    # Fetch the latest timestamp
    get "/devices/#{device_id}/latest_reading"
    json_response = JSON.parse(response.body)
    expect(json_response['latest_timestamp']).to eq('2021-09-29T16:09:15+01:00')
  end

  # POST /devices/:id/readings - duplicate readings
  it 'ignores duplicate timestamps and stores only unique readings' do
    post "/devices/#{device_id}/readings", params: duplicate_readings

    expect(response).to have_http_status(:ok)

    # Fetch the cumulative count
    get "/devices/#{device_id}/cumulative_count"
    json_response = JSON.parse(response.body)
    expect(json_response['cumulative_count']).to eq(2) # Only the first reading should be counted

    # Fetch the latest timestamp
    get "/devices/#{device_id}/latest_reading"
    json_response = JSON.parse(response.body)
    expect(json_response['latest_timestamp']).to eq('2021-09-29T16:08:15+01:00')
  end
end
