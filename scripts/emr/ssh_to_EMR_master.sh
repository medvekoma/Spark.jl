#!/bin/bash


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"


echo "Querying master IP: ${SCRIPT_DIR}/get_master_node_ip.sh"
MASTER_IP=$(${SCRIPT_DIR}/get_master_node_ip.sh)


#EMR_USER="ec2-user"
EMR_USER="hadoop"


echo "SSH to EMR master node: ${EMR_USER}@${MASTER_IP}"
ssh  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oServerAliveInterval=30 -i ${SCRIPT_DIR}/DevTeamEPAM.pem ${EMR_USER}@${MASTER_IP}