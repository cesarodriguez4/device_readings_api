require 'rails_helper'

RSpec.describe DevicesController, type: :controller do
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
        { timestamp: '2021-09-29T16:08:15+01:00', count: 2 },
        { timestamp: '2021-09-29T16:08:15+01:00', count: 10 }
      ]
    }
  end

  let(:out_of_order_readings) do
    {
      readings: [
        { timestamp: '2021-09-29T16:09:15+01:00', count: 15 },
        { timestamp: '2021-09-29T16:08:15+01:00', count: 2 }
      ]
    }
  end

  describe 'POST /devices/:id/readings' do
    context 'with valid readings' do
      it 'stores readings successfully and returns 200' do
        post :readings, params: { id: device_id }.merge(valid_readings)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with duplicate readings' do
      it 'ignores duplicate timestamps and stores only unique readings' do
        post :readings, params: { id: device_id }.merge(duplicate_readings)
        get :cumulative_count, params: { id: device_id }
        json_response = JSON.parse(response.body)
        expect(json_response['cumulative_count']).to eq(2)
      end
    end

    context 'with out-of-order readings' do
      it 'stores readings in any orders and handles them correctly' do
        post :readings, params: { id: device_id }.merge(out_of_order_readings)
        expect(response).to have_http_status(:ok)
        get :latest_reading, params: { id: device_id }
        json_response = JSON.parse(response.body)
        expect(json_response['latest_timestamp']).to eq('2021-09-29T16:09:15+01:00')
      end
    end
  end

  describe 'GET /devices/:id/latest_reading' do
    context 'when readings exist' do
      it 'returns the latest timestamp' do
        post :readings, params: { id: device_id }.merge(valid_readings)
        get :latest_reading, params: { id: device_id }
        json_response = JSON.parse(response.body)
        expect(json_response['latest_timestamp']).to eq('2021-09-29T16:09:15+01:00')
      end
    end

    context 'when no readings exist' do
      it 'returns a 404 with device not found error' do
        get :latest_reading, params: { id: device_id }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Device not found')
      end
    end
  end

  describe 'GET /devices/:id/cumulative_count' do
    context 'when readings exist' do
      it 'returns the cumulative count' do
        post :readings, params: { id: device_id }.merge(valid_readings)
        get :cumulative_count, params: { id: device_id }
        json_response = JSON.parse(response.body)
        expect(json_response['cumulative_count']).to eq(17)
      end
    end

    context 'when no readings exist' do
      it 'returns a 404 with device not found error' do
        get :cumulative_count, params: { id: device_id }
        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Device not found')
      end
    end
  end
end
