#!/bin/sh

command -v jq >/dev/null 2>&1 || { echo >&2 "This script requires jq. Install it from https://stedolan.github.io/jq/download/"; exit 1; }

#CLUSTER_ID="j-2JZDVN1ZWB5XJ"
#
#if [ -z "$CLUSTER_ID" ]; then
#	echo -n "Please provide an EMR cluster ID [ENTER]: "
#	read CLUSTER_ID
#fi
#
#aws emr describe-cluster --cluster-id $CLUSTER_ID | jq -r .Cluster.MasterPublicDnsName | while read line; do
#    echo $line
#done


cat cluster.json | jq -r .Cluster.MasterPublicDnsName | while read line; do
    echo $line
done
