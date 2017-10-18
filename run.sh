#!/bin/bash

deploy_produnction(){
  dotnet lambda deploy-function user-removal-prod --region us-east-1 $*;
}

deploy_development(){
  dotnet lambda deploy-function user-removal-dev --region us-east-1 $*;
}

deploy_stagging(){
  dotnet lambda deploy-function user-removal-stag --region us-east-1 $*;
}

dotnet restore;
if [ $CIRCLE_BRANCH = "master" -o $CIRCLE_BRANCH = "dev" -o $CIRCLE_BRANCH = "staging" ];
then
  apt-get update && apt-get install python-pip zip unzip -y;
  pip install awscli;
  export PATH=~/.local/bin:$PATH;
  aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID ;
  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY ;
  aws configure set region us-east-1;
  aws configure set output json
  Lambda_func_config='-frole arn:aws:iam::275485857435:role/user-removal-service-lambda -fsub subnet-a88614e0,subnet-55db070f --function-security-groups sg-b9b543c8';
  case "$CIRCLE_BRANCH" in
    "master") deploy_produnction $Lambda_func_config
    ;;
    "dev") deploy_produnction $Lambda_func_config
    ;;
    "staging") deploy_stagging $Lambda_func_config
    ;;
  esac
else
  dotnet build;
fi
