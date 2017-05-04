#!/bin/sh
# Prepare EMR master node for regular tasks.
# install mc, git
# Configure working copy of Spark.jl git repo for commit & push


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"


echo "Querying master IP: ${SCRIPT_DIR}/get_master_node_ip.sh"
EMR_MASTER_IP=$(${SCRIPT_DIR}/get_master_node_ip.sh)


#EMR_USER="ec2-user"
EMR_USER="hadoop"


GIT_PUSH_ORIGIN="https://github.com/Kalman85/Spark.jl"
# provide GIT_USER_* variables externally
: ${GIT_USER_EMAIL:=""}
: ${GIT_USER_NAME:=""}


echo "Preparing EMR master node for development: ${EMR_USER}@${EMR_MASTER_IP}"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oServerAliveInterval=30 \
    -i ${SCRIPT_DIR}/DevTeamEPAM.pem  \
    -n hadoop@${EMR_MASTER_IP} \
    "sudo yum -y install mc git; cd /home/hadoop/.julia/v0.5/Spark; git remote set-url --push origin ${GIT_PUSH_ORIGIN}; git config --global user.email \"${GIT_USER_EMAIL}\";  git config --global user.name \"${GIT_USER_NAME}\""

