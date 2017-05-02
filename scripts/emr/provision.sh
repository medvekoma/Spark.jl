#!/bin/bash


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #"

CLUSTER_NAME=${1-${USER}-juliapoc}
CORE_COUNT=3
TASK_COUNT=0
SPOT_BIDPRICE=0.09
INSTANCE_TYPE=c4.xlarge

: ${SPARKJL_REPO:="JohnAdders"}
: ${SPARKJL_BRANCH:="shared"}

echo "Bootstrapping from the github repo $SPARKJL_REPO/$SPARKJL_BRANCH..."

S3_BUCKET=s3://fms.develop
S3_SCRIPTS=$S3_BUCKET/app/scripts
S3_BOOTSTRAP=$S3_SCRIPTS/bootstrap.sh
S3_LOG=$S3_BUCKET/logs

KEY_NAME=DevTeamEPAM
SUBNET_ID=subnet-b23327d6

# set AWS_PROFILE to empty string if you use access_key environment variables 
# instead of AWS profiles
#AWS_PROFILE="--profile fms-playground"
AWS_PROFILE=""

aws s3 cp --recursive . $S3_SCRIPTS/ ${AWS_PROFILE}

RESULT=$(
    aws emr create-cluster \
	--name "$CLUSTER_NAME" \
	--ec2-attributes KeyName=$KEY_NAME,SubnetId=$SUBNET_ID,InstanceProfile="EMR_EC2_DefaultRole" \
	--service-role EMR_DefaultRole \
	--release-label emr-5.4.0 \
	--applications Name=Spark \
	--bootstrap-action Path=$S3_BOOTSTRAP,Args=[$SPARKJL_REPO,$SPARKJL_BRANCH] \
	--log-uri $S3_LOG \
	--instance-groups \
	  InstanceGroupType=MASTER,InstanceCount=1,InstanceType=$INSTANCE_TYPE,BidPrice=$SPOT_BIDPRICE \
	  InstanceGroupType=CORE,InstanceCount=$CORE_COUNT,InstanceType=$INSTANCE_TYPE,BidPrice=$SPOT_BIDPRICE \
	${AWS_PROFILE}
)
#	--steps \
#	  Type=CUSTOM_JAR,Name=Setup,ActionOnFailure=CANCEL_AND_WAIT,Jar=s3://us-west-1.elasticmapreduce/libs/script-runner/script-runner.jar,Args=["$S3_RUN"] 

#	--auto-terminate \
#	  InstanceGroupType=TASK,InstanceCount=$TASK_COUNT,InstanceType=$INSTANCE_TYPE,BidPrice=$SPOT_BIDPRICE \



if [ -z "${RESULT}" ]; then
    echo "Failed to create EMR cluster."
    exit 1
fi
echo -e "RESULT of create-cluster: \"${RESULT}\""



#echo -e ${RESULT} | grep ClusterId | awk '{print $2}' | tr -d \"
CLUSTER_ID=$(echo -e "${RESULT}" | grep ClusterId | awk '{print $2}' | tr -d \")
echo "Cluster ID: ${CLUSTER_ID}"
echo "AWS Management Console URL: https://console.aws.amazon.com/elasticmapreduce/home?region=eu-west-1#cluster-details:${CLUSTER_ID}"




#aws emr wait cluster-running --cluster-id ${CLUSTER_ID} --profile ${AWS_PROFILE}
previous_state=''
while true; do
  json=$(aws emr describe-cluster --cluster-id ${CLUSTER_ID} ${AWS_PROFILE}) # see http://docs.aws.amazon.com/cli/latest/reference/emr/describe-cluster.html
  state=$(echo "${json}" | jq -r '.Cluster.Status.State')
  # echo state changes
  if [[ ${state} != ${previous_state} ]]; then
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ") # format date as ISO 8601 UTC
    message=$(echo "${json}" | jq -r '.Cluster.Status.StateChangeReason.Message')
    echo "${now} ${state} ${message}"
    previous_state="${state}"
  fi

  if [[ ${state} == WAITING ]]; then
    break
  fi
  if [[ ${state} == TERMINATED ]]; then
    break
  fi
  if [[ ${state} == TERMINATED_WITH_ERRORS ]]; then
    break
  fi
  sleep 10
done
#echo "State of the cluster: ${state}"



# Save output of describe-cluster into cluster.json
${SCRIPT_DIR}/describe_cluster.sh ${CLUSTER_ID}