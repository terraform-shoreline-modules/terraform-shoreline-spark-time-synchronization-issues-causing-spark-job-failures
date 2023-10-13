

#!/bin/bash



# Define the NTP server IP address or hostname

NTP_SERVER=${NTP_SERVER}



# Define the NTP server port (default is 123)

NTP_PORT=${NTP_PORT}



# Define the NTP client command (ntpdate is used here)

NTP_CLIENT_CMD="ntpdate -q $NTP_SERVER"



# Run the NTP client command and capture the output

NTP_CLIENT_OUTPUT=$($NTP_CLIENT_CMD 2>&1)



# Check if the NTP client command succeeded (exit code 0)

if [ $? -eq 0 ]; then

    echo "NTP server configuration is correct"

else

    echo "NTP server configuration is incorrect"

    echo "Error message: $NTP_CLIENT_OUTPUT"

fi