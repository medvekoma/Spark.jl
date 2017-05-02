#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"


command -v jq >/dev/null 2>&1 || { echo >&2 "This script requires jq. Install it from https://stedolan.github.io/jq/download/"; exit 1; }

: ${SPARKJL_REPO:="JohnAdders"}
: ${SPARKJL_BRANCH:="shared"}

echo "Re-deploying Spark.Jl from $SPARKJL_REPO/$SPARKJL_BRANCH..."

CLUSTER_ID=$1
if [ -z "$CLUSTER_ID" ]; then
	echo -n "Please provide an EMR cluster ID [ENTER]: "
	read CLUSTER_ID
fi

aws emr list-instances --cluster-id $CLUSTER_ID | jq -r .Instances[].PublicDnsName | while read line; do 
	node=`echo $line | sed 's/[^a-zA-Z0-9\.\-]//g'` 
	echo "--- $node ---"
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -oServerAliveInterval=30 -i ${SCRIPT_DIR}/DevTeamEPAM.pem  -n hadoop@$node "julia -e '
		Pkg.free(\"Spark\")
		Pkg.rm(\"Spark\")
		Pkg.clone(\"https://github.com/'$SPARKJL_REPO'/Spark.jl\")
		Pkg.checkout(\"Spark\", \"'$SPARKJL_BRANCH'\")
		Pkg.build()
	'"
done



# rebuild Spark.jl on master 
EMR_MASTER_IP=$(${SCRIPT_DIR}/get_master_node_ip.sh)
echo -e "\n\n\nRebuild Spark.jl on EMR master: $EMR_MASTER_IP"
ssh -i ${SCRIPT_DIR}/DevTeamEPAM.pem  -n hadoop@${EMR_MASTER_IP} "cd /home/hadoop/.julia/v0.5/Spark/jvm/sparkjl; mvn clean package -P yarn"

