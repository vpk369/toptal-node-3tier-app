##run with caution - only when you are redepoying entire stacks
```
aws secretsmanager delete-secret --secret-id PROD/Toptal/ApiEB --force-delete-without-recovery --profile ToptalAdmin 
aws secretsmanager delete-secret --secret-id PROD/Toptal/WebEB --force-delete-without-recovery --profile ToptalAdmin
#####aws secretsmanager delete-secret --secret-id PROD/Toptal/DBCred --force-delete-without-recovery --profile ToptalAdmin

##for windows
proj-root$ find . -type f -name "*.sh" | xargs dos2unix $1

 aws elasticbeanstalk list-available-solution-stacks --profile ToptalAdmin | grep -i node

 64bit Amazon Linux 2018.03 v4.14.1 running Node.js
```
--------------
--------------
Stack run order: in init.sh

------------------
fix: 
     ssh is open for eb instances -- done?
     replace all hardcoded values to use variables - done
     setup cloud front cdn -- done but commented
     save dburl and eburl to secrets or else generate in deploy script and save in both apps -done 

#reference for postgresql DB Setup: 
https://console.aws.amazon.com/cloudformation/designer/home?templateURL=https://s3.amazonaws.com/aws-database-blog/artifacts/aws-aurora-cloudformation-samples/cftemplates/Aurora-Postgres-DB-Cluster.yml&region=us-east-1

#reference for waf
https://docs.aws.amazon.com/solutions/latest/aws-waf-security-automations/template.html


gitlab variables for CI/CD (api & web)
--------------
 
AWS_ACCESS_KEY_ID        xxxxxxxxxxxx
AWS_SECRET_ACCESS_KEY    xxxxxxxx
AWS_BASE_REGION           us-east-1
DEPLOY_TIER              allowed valuse are: Web / Api / Both
ECR_API_REPO_URL             894541307925.dkr.ecr.us-east-1.amazonaws.com/toptal-api
ECR_WEB_REPO_URL             894541307925.dkr.ecr.us-east-1.amazonaws.com/toptal-web




# ToptalPOC

Here are the prerequisites for infrastructure creation and provisiniong of aws resources
- ansible client
- awscli

After finishing checklist of items, run the command on your local machine and hit enter
```
aws configure --profile ToptalAdmin
```
and then enter the following details
```

AWS Access Key ID [None]:         <enter access key provided in shared file and hit enter>
AWS Secret Access Key [None]:      <enter secret key provided in shared file and hit enter>
Default region name [None]:        us-east-1
Default output format [None]:      <just hit enter>

```

For every aws command you run, make sure you add the option ```--profile ToptalAdmin``` so that the cli will consider this keys


Infrastructure setup will be launched from local machine

Web application deployment will be done from Bastion host (publicly accessible) as our 3 servers (2 webservers, 1 proxy load balancer) are in private network and we don't have vpn setup.

* You must configure profile in the bastion host as per aforementioned instructions

Infrastructure setup/update commands:
------------------------------
```
git clone https://github.com/VamshiManikonda/ToptalPOC.git
git pull
cd ToptalPOC/cloudformation/
bash init.sh

```
when you run above command, CloudFormation stacks will be created at https://console.aws.amazon.com/cloudformation/home?region=us-east-1

Use the pem file 'ToptalKey' to ssh on to Bastion host and other instaances via Bastion host.



