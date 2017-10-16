#!/bin/bash

if [ $CIRCLE_BRANCH = "master" ] || [$CIRCLE_BRANCH = "dev"] || [$CIRCLE_BRANCH = "staging"]
then
  apt-get update && apt-get install python-pip zip unzip -y;
  pip install awscli;
  export PATH=~/.local/bin:$PATH;
  aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID ;
  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY ;
  aws configure set region us-east-1;
  dotnet restore;
  dotnet lambda deploy-function LambdaFunCSharp --function-role lambda_basic_execution;
else
  dotnet restore;
  dotnet build;
fi
