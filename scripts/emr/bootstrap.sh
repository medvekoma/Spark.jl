#!/bin/bash

# install julia
curl -s https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.1-linux-x86_64.tar.gz | sudo tar -xz -C /usr/local/
JULIA_DIR=/usr/local/julia-6445c82d00

# install maven
curl -s http://mirror.olnevhost.net/pub/apache/maven/binaries/apache-maven-3.2.2-bin.tar.gz | sudo tar -xz -C /usr/local/
MAVEN_DIR=/usr/local/apache-maven-3.2.2
export PATH=$MAVEN_DIR/bin:$PATH

# set environment variables
declare -a users=("hadoop" "ec2-user")
for usr in "${users[@]}"; do
   ENV_FILE=/home/${usr}/.bashrc
   sudo echo "" >> ${ENV_FILE}
   sudo echo "export JAVA_HOME=/usr/lib/jvm/java" >> ${ENV_FILE}
   sudo echo "export SPARK_HOME=/usr/lib/spark/" >> ${ENV_FILE}
   sudo echo "export HADOOP_CONF_DIR=/etc/hadoop/conf" >> ${ENV_FILE}
   sudo echo "export YARN_CONF_DIR=/etc/hadoop/conf" >> ${ENV_FILE}
   sudo echo "export PATH=${PATH}:${MAVEN_DIR}/bin:${JULIA_DIR}/bin" >> ${ENV_FILE}
done

export SPARKJL_PROFILE=yarn

# setup spark julia binding
$JULIA_DIR/bin/julia -e 'Pkg.clone("https://github.com/'$1'/Spark.jl");Pkg.checkout("Spark","'$2'");Pkg.build("Spark")'
