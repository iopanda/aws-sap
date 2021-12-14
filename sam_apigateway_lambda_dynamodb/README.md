[Installing the AWS SAM CLI on Linux](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install-linux.html)

## Install SAM CLI

1. Download the AWS SAM CLI zip file to a directory of your choice.
```bash
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
```

2.Verify the integrity and authenticity of the downloaded installer files by 
generating a hash value using the following command:
```bash
sha256sum aws-sam-cli-linux-x86_64.zip
```
The output should look like the following example:
```bash
 <64-character SHA256 hash value> aws-sam-cli-linux-x86_64.zip
```

3. Unzip the installation files into the sam-installation/ subdirectory.
```bash
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
```

4. Install the AWS SAM CLI.
```bash
sudo ./sam-installation/install
```

5. Verify the installation.
```bash
sam --version
```
On successful installation, you should see output like the following:
```bash
SAM CLI, version 1.33.0
```

## How to use SAM deploy stuffs

```bash
#Step 1 - Download a sample application
sam init

#Step 2 - Build your application
cd sam-app
sam build

#Step 3 - Deploy your application
sam deploy --guided
```

*In this lab we only need to excute step 3*

## Clear up resources deployed by SAM (region: ap-northeast-1)
```bash
aws cloudformation delete-stack --stack-name sam-app --region ap-northeast-1
```


For example:
```bash
[ec2-user@ip-172-31-37-50 sam_apigateway_lambda_dynamodb]$ 
[ec2-user@ip-172-31-37-50 sam_apigateway_lambda_dynamodb]$ sam deploy --guided

Configuring SAM deploy
======================

Looking for config file [samconfig.toml] :  Not found

Setting default arguments for 'sam deploy'
=========================================
Stack Name [sam-app]: sam-app
AWS Region [ap-northeast-1]: 
#Shows you resources changes to be deployed and require a 'Y' to initiate deploy
Confirm changes before deploy [y/N]: y
#SAM needs permission to be able to create roles to connect to the resources in your template
Allow SAM CLI IAM role creation [Y/n]: y
DDBHandlerFunction may not have authorization defined, Is this okay? [y/N]: y
DDBHandlerFunction may not have authorization defined, Is this okay? [y/N]: y
DDBHandlerFunction may not have authorization defined, Is this okay? [y/N]: y
DDBHandlerFunction may not have authorization defined, Is this okay? [y/N]: y
Save arguments to configuration file [Y/n]: y
SAM configuration file [samconfig.toml]:  
SAM configuration environment [default]: 
```