

#!/bin/bash



NTP_SERVER=${NTP_SERVER_ADDRESS}



# Install NTP

sudo apt-get update

sudo apt-get install -y ntp



# Set NTP server

sudo sed -i "s/^pool\ 0.ubuntu.pool.ntp.org/#pool\ 0.ubuntu.pool.ntp.org/" /etc/ntp.conf

sudo sed -i "s/^pool\ 1.ubuntu.pool.ntp.org/#pool\ 1.ubuntu.pool.ntp.org/" /etc/ntp.conf

sudo sed -i "s/^pool\ 2.ubuntu.pool.ntp.org/#pool\ 2.ubuntu.pool.ntp.org/" /etc/ntp.conf

sudo sed -i "s/^pool\ 3.ubuntu.pool.ntp.org/#pool\ 3.ubuntu.pool.ntp.org/" /etc/ntp.conf

sudo sed -i "s/^#NTP_SERVER/NTP_SERVER/" /etc/ntp.conf

sudo sed -i "s/ntp.ubuntu.com/$NTP_SERVER/" /etc/ntp.conf



# Restart NTP service

sudo systemctl restart ntp





chmod +x configure_ntp.sh





./configure_ntp.sh