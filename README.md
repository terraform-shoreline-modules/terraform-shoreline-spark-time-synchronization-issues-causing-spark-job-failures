
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Time synchronization issues causing Spark job failures.
---

This incident type refers to issues encountered in a Spark cluster where Spark jobs are failing due to time synchronization problems between the nodes in the cluster. These synchronization issues can cause data inconsistencies and errors in Spark applications, which can lead to job failures. To resolve this issue, it is necessary to ensure that all nodes in the cluster have synchronized time.

### Parameters
```shell
export LIST_OF_CLUSTER_NODES="PLACEHOLDER"

export NTP_SERVER_ADDRESS="PLACEHOLDER"

export NTP_PORT="PLACEHOLDER"

export NTP_SERVER="PLACEHOLDER"
```

## Debug

### Check the time on each node in the Spark cluster
```shell
for node in ${LIST_OF_CLUSTER_NODES}; do ssh $node date; done
```

### Check the time synchronization status of each node in the cluster
```shell
for node in ${LIST_OF_CLUSTER_NODES}; do ssh $node timedatectl status; done
```

### Check the NTP daemon status on each node in the cluster
```shell
for node in ${LIST_OF_CLUSTER_NODES}; do ssh $node systemctl status ntpd; done
```

### Check the NTP daemon configuration on each node in the cluster
```shell
for node in ${LIST_OF_CLUSTER_NODES}; do ssh $node cat /etc/ntp.conf; done
```

### Restart the NTP daemon on each node in the cluster
```shell
for node in ${LIST_OF_CLUSTER_NODES}; do ssh $node systemctl restart ntpd; done
```

### Check the time synchronization status again after restarting the NTP daemon
```shell
for node in ${LIST_OF_CLUSTER_NODES}; do ssh $node timedatectl status; done
```

### Incorrect NTP (Network Time Protocol) server configuration on one or more nodes in the cluster.
```shell


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


```

## Repair

### Configure NTP (Network Time Protocol) on all nodes in the Spark cluster to ensure that time synchronization is consistent across all nodes.
```shell


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


```