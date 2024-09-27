class DevicesController < ApplicationController
  before_action :set_device, only: %i[readings latest_reading cumulative_count]

  # POST /devices/:id/readings
  def readings
    readings_data = readings_params[:readings]

    readings_data.each do |reading|
      timestamp = reading[:timestamp]
      count = reading[:count]

      # Ignore duplicate readings (by timestamp)
      @device.readings[timestamp] = count unless @device.readings.key?(timestamp)
    end

    head :ok
  end

  # GET /devices/:id/latest_reading
  def latest_reading
    latest_timestamp = @device.readings.keys.max

    render json: { latest_timestamp: }
  end

  # GET /devices/:id/cumulative_count
  def cumulative_count
    cumulative_count = @device.readings.values.map(&:to_i).sum

    render json: { cumulative_count: }
  end

  private

  # Method to find the device and initialize in-memory storage if needed
  def set_device
    @device = Device.find_or_initialize_by(id: params[:id])
  end

  # Strong parameters for readings
  def readings_params
    params.permit(readings: %i[timestamp count])
  end
end
