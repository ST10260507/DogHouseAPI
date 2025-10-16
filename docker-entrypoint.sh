#!/bin/bash

# Use a separate, robust environment variable for the raw JSON.
# The value of GCP_SERVICE_ACCOUNT_JSON will be the raw, multiline JSON from Render.

# Check if the GCP_SERVICE_ACCOUNT_JSON variable is set and non-empty
if [ -z "$GCP_SERVICE_ACCOUNT_JSON" ]; then
    echo "Warning: GCP_SERVICE_ACCOUNT_JSON is not set. Assuming default ADC."
else
    # Write the content of the variable to the credentials file path
    # We use 'printf' here to correctly handle embedded newlines in the raw JSON value
    printf "%s" "$GCP_SERVICE_ACCOUNT_JSON" > /etc/gcp_credentials.json
    echo "GCP credentials file successfully written to /etc/gcp_credentials.json"
fi

# Execute the main application
echo "Starting .NET application..."
exec dotnet DogHouseAPI.dll