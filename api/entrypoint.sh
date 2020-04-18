#!/bin/bash

AWS_REGION='us-east-1'
SECRETS_EB='PROD/Toptal/ApiEB'
SECRETS_DB='PROD/Toptal/DBCred'
EB_CONFIG_DIR='.elasticbeanstalk'
EB_EXT_DIR='.ebextensions'
SSH_KEY_NAME='toptal-screening'
VPN_SG='Toptal-PROD-VPN'

home_dir='/opt/config'
vars_file="$home_dir/vars"
secrets_file="$home_dir/secrets.json"
secrets_eb_file="$home_dir/secrets_eb.json"
secrets_db_file="$home_dir/secrets_db.json"

if [ ! -d $home_dir ]; then
	mkdir $home_dir
fi

aws --output json --region $AWS_REGION \
      secretsmanager get-secret-value --secret-id $SECRETS_EB | jq --raw-output '.SecretString' > $secrets_eb_file

aws --output json --region $AWS_REGION \
      secretsmanager get-secret-value --secret-id $SECRETS_DB | jq --raw-output '.SecretString' > $secrets_db_file

# merging 2 secrets
jq -s '.|add' $secrets_eb_file $secrets_db_file > $secrets_file

# putting secrets as bash variables
jq -r 'to_entries|map(.key+"="+.value|tostring)|.[]' $secrets_file > $vars_file
chmod +x $vars_file

. $vars_file

#update .ebextensions/config.yml file
sed -i "s#%EB_APP_NAME%#${EB_APPLICATION_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%EB_APP_NAME%#${EB_APPLICATION_NAME}#g" .gitlab-ci.yml
sed -i "s#%SSH_KEY_NAME%#${SSH_KEY_NAME}#g" $EB_CONFIG_DIR/config.yml
sed -i "s#%AWS_REGION%#${AWS_REGION}#g" $EB_CONFIG_DIR/config.yml

sed -i "s#%SECURITY_GROUP%#${VPN_SG}#g" $EB_EXT_DIR/02-launch.config

#create env varas for this app
echo "DB=$CONN_STRING" > .env
echo "PORT=80" >> .env
chmod +r .env

# removing temp files
rm -f $secrets_file $secrets_db_file $secrets_eb_file $vars_file

#start node
node ./bin/www