#!/bin/bash

#initialize the entire stack

source vars.sh

# create or update stack will be done by 'deploy' subcommand
# if you dont want to use default values
#--------> $ aws cloudformation deploy --template-file file://<-------templates/<stack-file-name>.yml --stack-name <stack-name> --parameter-overrides Key1=Value1 Key2=Value2

# aws cloudformation deploy --template-file templates/network-stack.yaml --stack-name Toptal-PROD-Network --profile ToptalAdmin --region=$AWS_REGION
# run WAF layer stack here
# aws cloudformation deploy --template-file templates/shared-infra.yaml --stack-name Toptal-PROD-Shared-Infra --profile ToptalAdmin --region=$AWS_REGION

# aws cloudformation deploy --template-file templates/security-groups.yaml --stack-name Toptal-PROD-SecurityGroups --profile ToptalAdmin --region=$AWS_REGION

# aws cloudformation deploy --template-file templates/db-stack.yaml --stack-name Toptal-PROD-DB --profile ToptalAdmin --region=$AWS_REGION --parameter-overrides UserPassword=$UserPassword

#aws cloudformation deploy --template-file templates/api-stack.yaml --stack-name Toptal-PROD-Api --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM #give permission to create role

aws cloudformation deploy --template-file templates/web-stack.yaml --stack-name Toptal-PROD-Web --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM #give permission to create role

echo -e "\n\n\nHere are the details of resources:"
aws cloudformation list-exports --query "Exports[*].{name:Name,value:Value}" --profile ToptalAdmin --region $AWS_REGION --output text