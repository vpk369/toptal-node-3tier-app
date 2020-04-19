#!/bin/bash

#initialize the entire stacks

source vars.sh
# echo $AWSDefaultRegion #testing only

# create or update stack will be done by 'deploy' subcommand
# if you dont want to use default values
##$ aws cloudformation deploy --template-file file://<-------templates/<stack-file-name>.yml --stack-name <stack-name> --parameter-overrides Key1=Value1 Key2=Value2

aws cloudformation deploy --template-file templates/network_stack.yaml --stack-name TouBisNetwork --profile TouBicAdmin --region=us-east-1

aws cloudformation deploy --template-file templates/webservers_stack.yaml --stack-name TouBisWebServers --profile TouBicAdmin --region=us-east-1

aws cloudformation deploy --template-file templates/loadbalancer_stack.yaml --stack-name TouBisWebLoadBalancers --profile TouBicAdmin --region=us-east-1

echo -e "\n\n\nHere are the details of resources:"
aws cloudformation list-exports --query "Exports[*].{name:Name,value:Value}" --profile TouBicAdmin --region us-east-1 --output text