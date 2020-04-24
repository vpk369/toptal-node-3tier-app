Checklist of items for kicking off the project in Virginia location of AWS account
----------------------------------------------------------------------------------

- Create an aws account
- Create user 'ToptalAdmin' with admin privileges with access keys enabled and save keys on secure location 
- If required, Create user 'ToptalReadOnly' with Read Only privileges with access keys enabled and save keys on secure location like Google Drive with private access 
- Create keypair with name 'toptal-screening' and save keys on secure location like Google Drive with private access
- Create a GitLab repo for Web Application code to deploy


On local machine:
-----------------

- Install AWS CLI based on your machine OS
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
  
- check if they are installed by running
```
aws --version
```
- Determine values for <a href="cloudformation/vars.sh">cloudformation/vvars.sh</a> and save it 
- Ensure that there is no S3 bucket named 'toptal-website-virginia' in virginia region. If you think that is needed and being used by other projects, launch the stack with different S3 bucket name in <a href="cloudformation/vars.sh">cloudformation/vvars.sh</a> file


- Generate ssh key pair by following instructions on https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

