#!/bin/bash

apt-get update && apt-get install python-pip zip unzip -y;
pip install awscli;
export PATH=~/.local/bin:$PATH;
aws configure set region us-east-1;
dotnet restore;
dotnet lambda deploy-function LambdaFunCSharp --function-role lambda_basic_execution;
