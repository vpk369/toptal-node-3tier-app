#!/bin/bash

#initialize the entire stack

source vars.sh

# create or update stack will be done by 'deploy' subcommand
# if you don't want to use default values, pass them using --parameter-overrides options as shown below:
#--------> $ aws cloudformation deploy --template-file file://<-------templates/<stack-file-name>.yml --stack-name <stack-name> --parameter-overrides Key1=Value1 Key2=Value2

aws cloudformation deploy --template-file templates/network-stack.yaml --stack-name Toptal-PROD-Network --profile ToptalAdmin --region=$AWS_REGION

PrivateSubnet1=$(aws cloudformation list-exports --query 'Exports[?Name==`Toptal-PROD-Network:PrivateSubnet1`].Value' --profile ToptalAdmin --region $AWS_REGION --output text)
PrivateSubnet2=$(aws cloudformation list-exports --query 'Exports[?Name==`Toptal-PROD-Network:PrivateSubnet2`].Value' --profile ToptalAdmin --region $AWS_REGION --output text)
PublicSubnet1=$(aws cloudformation list-exports --query 'Exports[?Name==`Toptal-PROD-Network:PublicSubnet1`].Value' --profile ToptalAdmin --region $AWS_REGION --output text)
PublicSubnet2=$(aws cloudformation list-exports --query 'Exports[?Name==`Toptal-PROD-Network:PublicSubnet2`].Value' --profile ToptalAdmin --region $AWS_REGION --output text)

aws cloudformation deploy --template-file templates/security-groups.yaml --stack-name Toptal-PROD-SecurityGroups --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_NAMED_IAM #give permission to create role

aws cloudformation deploy --template-file templates/shared-infra.yaml --stack-name Toptal-PROD-Shared-Infra --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy --template-file templates/db-stack.yaml --stack-name Toptal-PROD-DB --profile ToptalAdmin --region=$AWS_REGION --parameter-overrides UserPassword=$UserPassword

aws cloudformation deploy --template-file templates/api-stack.yaml --stack-name Toptal-PROD-Api --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM \
          --parameter-overrides EBSubnet="$PrivateSubnet1,$PrivateSubnet2" ALBSubnets="$PublicSubnet1,$PublicSubnet2"

aws cloudformation deploy --template-file templates/web-stack.yaml --stack-name Toptal-PROD-Web --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM \
          --parameter-overrides EBSubnet="${PrivateSubnet1},${PrivateSubnet2}"  ALBSubnets="${PublicSubnet1},${PublicSubnet2}"

## aws cloudformation deploy --template-file templates/waf-security.yaml --stack-name Toptal-WAF-Security --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM #give permission to create role

echo -e "\n\n\nHere are the details of resources:"
aws cloudformation list-exports --query "Exports[*].{name:Name,value:Value}" --profile ToptalAdmin --region $AWS_REGION --output text