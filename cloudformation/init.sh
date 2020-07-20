#!/bin/bash

#initialize the entire stack

source vars.sh

# create or update stack will be done by 'deploy' subcommand
# if you don't want to use default values, pass them using --parameter-overrides options as shown below:
#--------> $ aws cloudformation deploy --template-file file://<-------templates/<stack-file-name>.yml --stack-name <stack-name> --parameter-overrides Key1=Value1 Key2=Value2

aws cloudformation deploy --template-file templates/network-stack.yaml --stack-name Toptal-PROD-Network --profile ToptalAdmin --region=$AWS_REGION

aws cloudformation deploy --template-file templates/security-groups.yaml --stack-name Toptal-PROD-SecurityGroups --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_NAMED_IAM #give permission to create role

aws cloudformation deploy --template-file templates/shared-infra.yaml --stack-name Toptal-PROD-Shared-Infra --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_NAMED_IAM

aws cloudformation deploy --template-file templates/db-stack.yaml --stack-name Toptal-PROD-DB --profile ToptalAdmin --region=$AWS_REGION --parameter-overrides UserPassword=$UserPassword

aws cloudformation deploy --template-file templates/api-stack.yaml --stack-name Toptal-PROD-Api --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM

aws cloudformation deploy --template-file templates/web-stack.yaml --stack-name Toptal-PROD-Web --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM

#aws cloudformation deploy --template-file templates/waf-security.yaml --stack-name Toptal-WAF-Security --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_IAM #give permission to create role

#aws cloudformation deploy --template-file templates/Wazuh.yaml --stack-name Toptal-PROD-Wazuh --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_NAMED_IAM --parameter-overrides ToolsUsername=$ToolsUsername ToolsPassword=$ToolsPassword

aws cloudformation deploy --template-file templates/ELK.yaml --stack-name Toptal-PROD-ELK --profile ToptalAdmin --region=$AWS_REGION --capabilities CAPABILITY_NAMED_IAM

echo -e "\n\n\nHere are the details of resources:"
aws cloudformation list-exports --query "Exports[*].{name:Name,value:Value}" --profile ToptalAdmin --region $AWS_REGION --output text 
