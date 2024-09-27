# frozen_string_literal: true

# DevicesController is a controller for managing devices and their readings.
class DevicesController < ApplicationController
  before_action :find_device, only: %i[latest_reading cumulative_count]

  # In-memory storage
  @@device_data = {}

  def readings
    device_id = params[:id]
    readings = params[:readings]

    readings.each do |reading|
      timestamp = reading['timestamp']
      count = reading['count']

      @@device_data[device_id] ||= {}

      # Ignoring duplicate timestamps
      @@device_data[device_id][timestamp] = count unless @@device_data[device_id].key?(timestamp)
    end

    head :ok
  end

  def latest_reading
    latest_timestamp = @device_data.keys.max
    render json: { latest_timestamp: }
  end

  def cumulative_count
    cumulative_count = if @device_data.is_a?(Hash)
                         @device_data.values.map(&:to_i).sum
                       else
                         0
                       end
    render json: { cumulative_count: }
  end

  private

  def find_device
    @device_data = @@device_data[params[:id]]
    render json: { error: 'Device not found' }, status: :not_found unless @device_data
  end
end
