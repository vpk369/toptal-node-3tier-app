
Checklist of items for kicking off the project in Virginia location of AWS account
----------------------------------------------------------------------------------

- Create aws account
- Create user 'ToptalAdmin' with admin privileges with access keys enabled and save keys on secure location like Google Drive with private access
- Create user 'ToptalReadOnly' with Read Only privileges with access keys enabled and save keys on secure location like Google Drive with private access 
- Create keypair with name 'ToptalKey' and save keys on secure location like Google Drive with private access
- Create a GitHub repo for Web Application code to deploy

On local machine:
-----------------

- Install AWS CLI based on your machine OS
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
  
- check if they are installed by running
```
aws --version
```
- Determine values for cloudformation/vars.sh and save it 
- Generate ssh key pair by following instructions on https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

