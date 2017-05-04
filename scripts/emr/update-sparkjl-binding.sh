#!/bin/sh

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"


command -v jq >/dev/null 2>&1 || {
  echo >&2 "This script requires jq. Install it from https://stedolan.github.io/jq/download/";
  exit 1;
}

: ${SPARKJL_REPO:="Kalman85"}
: ${SPARKJL_BRANCH:="shared"}

echo "Re-deploying Spark.Jl from $SPARKJL_REPO/$SPARKJL_BRANCH..."

CLUSTER_ID=$1
if [ -z "$CLUSTER_ID" ]; then
	echo -n "Please provide an EMR cluster ID [ENTER]: "
	read CLUSTER_ID
fi

pids=""
RESULT=0

aws emr list-instances --cluster-id $CLUSTER_ID | jq -r .Instances[].PublicDnsName | while read line; do 
	node=`echo $line | sed 's/[^a-zA-Z0-9\.\-]//g'` 
	echo "--- $node ---"
	ssh -n $node "
	    export SPARKJL_PROFILE='yarn'; julia -e '
            Pkg.free(\"Spark\")
            Pkg.rm(\"Spark\")
            Pkg.clone(\"https://github.com/'$SPARKJL_REPO'/Spark.jl\")
            Pkg.checkout(\"Spark\", \"'$SPARKJL_BRANCH'\")
            Pkg.build()
        '" > $node.log &
	pids="$pids $!"
done

echo ">>> pids = $pids"

for pid in $pids; do
	echo ">>> waiting for $pid..."
	wait $pid || let "RESULT=1"
done

if [ "$RESULT" == "1" ]; then
	echo ">>> ERROR - check logs"
	exit 1
fi

