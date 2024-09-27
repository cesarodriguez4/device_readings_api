
# Device Readings API

## Overview

This is a simple API for processing and storing device readings in memory. The API allows:    

- Storing readings for devices
- Retrieving the latest reading's timestamp for a device
- Retrieving the cumulative count of readings for a device

**Note:** This API does not persist data to disk. All data is stored in-memory and will be lost when the server is restarted.

## Setup Instructions

### Prerequisites

Ensure you have the following installed:    

- Ruby (version 3.3.4 or higher)
- Rails (version 7.1.3 or higher)
- Bundler

### Clone the Repository

```bash
git clone https://github.com/cesarodriguez4/device_readings_api.git
cd device_readings_api
```

### Install Dependencies

```bash
bundle install
```

### Run the Server

```bash
rails server
```

By default, the API will be accessible at `http://localhost:3000`.

## API Endpoints

### 1. Submit Readings for a Device (POST /devices/:id/readings)

**Description:** Submit device readings, ensuring no duplicate timestamps are stored.

- **Method:** POST
- **URL:** `/devices/:id/readings`
- **Request Body:**
    ```json
    {
        "readings": [
            {
                "timestamp": "2021-09-29T16:08:15+01:00",
                "count": 2
            },
            {
                "timestamp": "2021-09-29T16:09:15+01:00",
                "count": 15
            }
        ]
    }
    ```
- **Response:** HTTP Status `200 OK`

### 2. Get Latest Reading's Timestamp (GET /devices/:id/latest_reading)

**Description:** Fetch the latest reading's timestamp for a device.

- **Method:** GET
- **URL:** `/devices/:id/latest_reading`
- **Response:**
    ```json
    {
        "latest_timestamp": "2021-09-29T16:09:15+01:00"
    }
    ```

### 3. Get Cumulative Count (GET /devices/:id/cumulative_count)

**Description:** Fetch the cumulative count of all readings for a device.

- **Method:** GET
- **URL:** `/devices/:id/cumulative_count`
- **Response:**
    ```json
    {
        "cumulative_count": 17
    }
    ```

## Running Tests

To run the test suite, use the following command:

```bash
bundle exec rspec
```

Tests are located in the `spec/` directory and ensure the API behaves as expected.

## Project Structure

- `app/controllers/devices_controller.rb`: Contains the logic for the API endpoints.
- `app/models/device.rb`: Handles in-memory data storage.
- `config/routes.rb`: Defines the API routes.
- `spec/`: Contains unit and integration tests for the API.

## Improvements

If I had more time, I would have included the following:    

1. **Error Handling Improvements**: 
   - More detailed error messages and response statuses for invalid input.
   - Validation on device UUID format and reading data structure.

2. **Concurrency and Scalability**: 
   - Use a distributed in-memory store like Redis to handle concurrent requests and make the API scalable.

3. **API Versioning**: 
   - Add API versioning to allow future enhancements without breaking existing clients.

4. **Rate Limiting**: 
   - Implement rate limiting to prevent abuse of the API.

5. **Pagination and Filtering**: 
   - Add pagination and filtering to the GET requests to handle large datasets efficiently.

6. **API Documentation**: 
   - Use Swagger or a similar tool to generate interactive API documentation.
