#!/bin/bash
# This scripts starts a SOCKS proxy to EMR master node.
# this is needd to access the Spark dashboard locally.


# any random empy port on your local computer will do.
PORT=8157


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"


echo "Querying master IP: ${SCRIPT_DIR}/get_master_node_ip.sh"
MASTER_IP="ec2-52-30-246-224.eu-west-1.compute.amazonaws.com"
#MASTER_IP=$(${SCRIPT_DIR}/get_master_node_ip.sh)



echo "Starting tunnel to port ${PORT} on host: hadoop@${MASTER_IP}"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oServerAliveInterval=30 \
    -i ${SCRIPT_DIR}/DevTeamEPAM.pem \
    -ND 8157 hadoop@${MASTER_IP}