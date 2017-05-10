#!/bin/sh

CLUSTER_NAME=${1-${USER}-juliapoc}
CORE_COUNT=3
TASK_COUNT=0
SPOT_BIDPRICE=0.09
INSTANCE_TYPE=c4.xlarge

: ${SPARKJL_REPO:="JohnAdders"}
: ${SPARKJL_BRANCH:="shared"}

echo "Bootstrapping from the github repo $SPARKJL_REPO/$SPARKJL_BRANCH..."

S3_BUCKET=s3://fms.develop/$USER
S3_SCRIPTS=$S3_BUCKET/app/scripts
S3_BOOTSTRAP=$S3_SCRIPTS/bootstrap.sh
S3_LOG=$S3_BUCKET/logs

KEY_NAME=DevTeamEPAM
SUBNET_ID=subnet-b23327d6

# set AWS_PROFILE to empty string if you use access_key environment variables 
# instead of AWS profiles
#AWS_PROFILE="--profile fms-playground"
AWS_PROFILE=""

aws s3 cp bootstrap.sh $S3_SCRIPTS/ ${AWS_PROFILE}

aws emr create-cluster \
	--name "$CLUSTER_NAME" \
    --configurations file://config.json \
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
#	--steps \
#	  Type=CUSTOM_JAR,Name=Setup,ActionOnFailure=CANCEL_AND_WAIT,Jar=s3://us-west-1.elasticmapreduce/libs/script-runner/script-runner.jar,Args=["$S3_RUN"] 

#	--auto-terminate \
#	  InstanceGroupType=TASK,InstanceCount=$TASK_COUNT,InstanceType=$INSTANCE_TYPE,BidPrice=$SPOT_BIDPRICE \
