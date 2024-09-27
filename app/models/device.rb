class Device
  # Store all devices in a class variable (simulating in-memory storage)
  @@devices = {}

  attr_accessor :id, :readings

  def initialize(id)
    @id = id
    @readings = {}
  end

  # Find a device by ID or create a new one if it doesn't exist
  def self.find_or_initialize_by(id:)
    @@devices[id] ||= Device.new(id)
  end

  # Store readings in memory
  # The readings are stored in a hash where the keys are timestamps and values are counts
  def store_readings(readings_data)
    readings_data.each do |reading|
      timestamp = reading[:timestamp]
      count = reading[:count]

      # Store only unique timestamps
      @readings[timestamp] ||= count
    end
  end

  # Get the latest timestamp from the readings
  def latest_reading
    @readings.keys.max
  end

  # Calculate the cumulative count across all readings
  def cumulative_count
    @readings.values.sum
  end

  # Clear all stored devices (useful for resetting in tests)
  def self.clear_all
    @@devices.clear
  end
end
