#!/bin/bash

AWS_REGION='us-east-1'
SECRETS_EB='PROD/Toptal/ApiEB'
SECRETS_WEB='PROD/Toptal/WebEB'
EB_CONFIG_DIR='.elasticbeanstalk'
EB_EXT_DIR='.ebextensions'
SSH_KEY_NAME='toptal-screening'
VPN_SG='Toptal-PROD-VPN'

home_dir='/opt/config'
vars_file="$home_dir/vars"

secrets_eb_file="$home_dir/secrets_eb.json"
secrete_web_file="$home_dir/secrete_web.json"

if [ ! -d $home_dir ]; then
	mkdir $home_dir
fi

aws --output json --region $AWS_REGION \
      secretsmanager get-secret-value --secret-id $SECRETS_EB | jq --raw-output '.SecretString' > $secrets_eb_file

aws --output json --region $AWS_REGION \
      secretsmanager get-secret-value --secret-id $SECRETS_WEB | jq --raw-output '.SecretString' > $secrete_web_file

# putting secrets as bash variables
jq -r 'to_entries|map(.key+"="+.value|tostring)|.[]' $secrets_web_file > $vars_file
chmod +x $vars_file

. $vars_file

#update .ebextensions/config.yml file
sed -i "s#%EB_APP_NAME%#${EB_APPLICATION_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%EB_APP_NAME%#${EB_APPLICATION_NAME}#g" .gitlab-ci.yml
sed -i "s#%SSH_KEY_NAME%#${SSH_KEY_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%AWS_REGION%#${AWS_REGION}#g" $EB_CONFIG_DIR/config.yml

sed -i "s#%SECURITY_GROUP%#${VPN_SG}#g" $EB_EXT_DIR/02-launch.config

# putting secrets as bash variables
jq -r 'to_entries|map(.key+"="+.value|tostring)|.[]' $secrets_eb_file > $vars_file
chmod +x $vars_file

. $vars_file

#note: EB_APPLICATION_URL is overridden with api eb app url as same var name exists in both of web and api secrets
echo "API_HOST=$EB_APPLICATION_URL" > .env
echo "PORT=80" >> .env
chmod +r .env

# removing temp files
rm -f  $secrets_db_file $secrets_eb_file $vars_file

#start node
node ./bin/www