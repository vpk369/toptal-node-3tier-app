#!/bin/bash

EB_CONFIG_DIR='.elasticbeanstalk'
EB_EXT_DIR='.ebextensions'
SSH_KEY_NAME='toptal-screening'
PORT=80

SECRETS_API_EB='PROD/Toptal/ApiEB'
secrets_api_eb_file='./secrets_api_eb.json'
SECRETS_WEB_EB='PROD/Toptal/WebEB'
secrets_web_eb_file='./secrets_web_eb.json'
SECRETS_DB='PROD/Toptal/DBCred'
secrets_db_file="$home_dir/secrets_db.json"

secrets_file='./secrets.json'
vars_file='/tmp/vars'

replace_web_placeholders() {
# replace placeholders in files
sed -i "s#%EB_WEB_APP_NAME%#${EB_WEB_APP_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%SSH_KEY_NAME%#${SSH_KEY_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%AWS_REGION%#${AWS_REGION}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%SECURITY_GROUP%#${VPN_SG}#g" $EB_EXT_DIR/02-launch.config
# Ensure ELK_STACK_IP value must include http(s) protocol in gitlab settings
sed -i "s#%ELK_STACK_IP%#${ELK_STACK_IP}#g" $EB_EXT_DIR/03-filebeat.config
sed -i "s#%ELK_STACK_IP%#${ELK_STACK_IP}#g" $EB_EXT_DIR/04-metricbeat.config

sed -i "s#%EB_API_APP_URL%#${EB_API_APP_URL}#g; s#%PORT%#${PORT}#g" ./entrypoint.sh
}

replace_api_placeholders() {
# replace placeholders in files
sed -i "s#%EB_API_APP_NAME%#${EB_API_APP_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%SSH_KEY_NAME%#${SSH_KEY_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%AWS_REGION%#${AWS_REGION}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%SECURITY_GROUP%#${VPN_SG}#g" $EB_EXT_DIR/02-launch.config
# Ensure ELK_STACK_IP value must include http(s) protocol in gitlab settings
sed -i "s#%ELK_STACK_IP%#${ELK_STACK_IP}#g" $EB_EXT_DIR/03-filebeat.config
sed -i "s#%ELK_STACK_IP%#${ELK_STACK_IP}#g" $EB_EXT_DIR/04-metricbeat.config

sed -i "s#%CONN_STRING%#${CONN_STRING}#g; s#%PORT%#${PORT}#g" ./entrypoint.sh
}

sed -i "s#%ECR_WEB_REPO_URL%#${ECR_WEB_REPO_URL}#g" ./web/Dockerrun.aws.json; # available in gitlab env vars
sed -i "s#%ECR_API_REPO_URL%#${ECR_API_REPO_URL}#g" ./api/Dockerrun.aws.json; # available in gitlab env vars

# pull_secrets_and_load_envvars
aws secretsmanager get-secret-value --secret-id $SECRETS_API_EB --output json --region $AWS_REGION | jq --raw-output '.SecretString' > $secrets_api_eb_file
aws secretsmanager get-secret-value --secret-id $SECRETS_WEB_EB --output json --region $AWS_REGION | jq --raw-output '.SecretString' > $secrets_web_eb_file
aws secretsmanager get-secret-value --secret-id $SECRETS_DB --output json --region $AWS_REGION     | jq --raw-output '.SecretString' > $secrets_db_file

# merging 3 secrets
jq -s ".|add" $secrets_db_file $secrets_api_eb_file $secrets_web_eb_file > $secrets_file

# putting secrets as bash variables
jq -r "to_entries|map(.key+\"=\"+.value|tostring)|.[]?" $secrets_file > $vars_file
chmod +x $vars_file
. $vars_file

VPN_SG=$(aws cloudformation list-exports --query 'Exports[?Name==`Toptal-PROD-SecurityGroups:VPNSgId`].Value' --region $AWS_REGION --output text)

cd web
replace_web_placeholders
cd ../api
replace_api_placeholders
cd ..