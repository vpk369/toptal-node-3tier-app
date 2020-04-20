#!/bin/bash

AWS_REGION='us-east-1'
SECRETS_API='PROD/Toptal/ApiEB'
SECRETS_WEB='PROD/Toptal/WebEB'
EB_CONFIG_DIR='.elasticbeanstalk'
EB_EXT_DIR='.ebextensions'
SSH_KEY_NAME='toptal-screening'
VPN_SG='Toptal-PROD-VPN'

home_dir='/opt/config'
vars_file="$home_dir/vars"

secrets_api_file="$home_dir/secrets_api.json"
secrete_web_file="$home_dir/secrete_web.json"

if [ ! -d $home_dir ]; then
	mkdir $home_dir
fi

aws --output json --region $AWS_REGION \
      secretsmanager get-secret-value --secret-id $SECRETS_API | jq --raw-output '.SecretString' > $secrets_api_file

aws --output json --region $AWS_REGION \
      secretsmanager get-secret-value --secret-id $SECRETS_WEB | jq --raw-output '.SecretString' > $secrete_web_file

# putting secrets as bash variables
jq -r 'to_entries|map(.key+"="+.value|tostring)|.[]' $secrets_web_file > $vars_file
chmod +x $vars_file

. $vars_file

#update .ebextensions/config.yml file
sed -i "s#%EB_WEB_APP_NAME%#${EB_WEB_APP_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%SSH_KEY_NAME%#${SSH_KEY_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%AWS_REGION%#${AWS_REGION}#g" $EB_CONFIG_DIR/config.yml

sed -i "s#%SECURITY_GROUP%#${VPN_SG}#g" $EB_EXT_DIR/02-launch.config

# putting secrets as bash variables
jq -r 'to_entries|map(.key+"="+.value|tostring)|.[]' $secrets_api_file > $vars_file
chmod +x $vars_file

. $vars_file

echo "API_HOST=$EB_API_APP_URL" > .env
echo "PORT=80" >> .env
chmod +r .env

# removing temp files
rm -f  $secrets_web_file $secrets_api_file $vars_file

#start node
node ./bin/www