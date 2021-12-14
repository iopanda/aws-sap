[doc](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-cli-tutorial-fargate.html)

## 可以使用 WinSCP 上传实验文件，节省时间. (部署 EC2 时，需要保存好 SSh Key)

## Step 1: 创建 ECS Task 执行时的 IAM Role。 (Task Execution IAM Role)

1. 创建名为 task-execution-assume-role.json 的文件，包含以下内容:

vim task-execution-assume-role.json

```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

2. 创建 task execution role:
```
aws iam --region us-west-2 create-role --role-name SapLabEcsTaskExecutionRole --assume-role-policy-document file://task-execution-assume-role.json
```

3. 附加 task execution role policy:
```
aws iam --region us-west-2 attach-role-policy --role-name SapLabEcsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
```

## Step 2: 安装 Amazon ECS CLI

1. 下载 Amazon ECS CLI
```
sudo curl -Lo /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
```

2. 使用 PGP 验证 Amazon ECS CLI 签名
```
sudo yum install gnupg
```

3. 创建如下文件 （目录里已包含）
```
pgp_pub_key
```

4. 使用如下命令导入 pgp 秘钥
```
gpg --import pgp_pub_key
```

5. 下载 AWS CLI 签名
```
curl -Lo ecs-cli.asc https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest.asc
```

6. 验证签名 
```
gpg --verify ecs-cli.asc /usr/local/bin/ecs-cli
```

7. 添加执行权
```
sudo chmod +x /usr/local/bin/ecs-cli
```

8. 完成安装
```
ecs-cli --version
```

## Step 3: 配置 Amazon ECS CLI

1. 创建 cluster configuration

```
ecs-cli configure --cluster sap-lab-ecs --default-launch-type FARGATE --config-name sap-lab-ecs --region us-west-2
```

2. 创建 CLI profile (使用 IAM ACCESS KEY):
[ACCESS KEY, SECRET KEY 需被替换成真实值]
```
ecs-cli configure profile --access-key AWS_ACCESS_KEY_ID --secret-key AWS_SECRET_ACCESS_KEY --profile-name sap-lab-ecs-profile
```

3. 使用 CLI 创建 ECS cluster, cluster configuration 已默认指定 FARGATE 为部署方式。
该命令会创建一个空的 cluster （集群）
[Note: 该命令的输出 (VPC_ID) 后续仍将被使用]
```
ecs-cli up --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```

4. 使用如下命令，获取 SG ID:  
[替换 VPC_ID, 该命令的输出 (GroupId) 后续仍将被使用]
```
aws ec2 describe-security-groups --filters Name=vpc-id,Values=VPC_ID --region us-west-2
```

5. 使用如下命令，添加一条入站规则，允许访问 port 80:  
[替换 SECURITY_GROUP_ID]
```
aws ec2 authorize-security-group-ingress --group-id SECURITY_GROUP_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region us-west-2
```

6.  创建 Compose File， 它会创建一个 web container 并将 web 访问导向 80 端口。
它还会创建相关 CloudWatch Log Group。 
```
File - docker-compose.yml
```

除了 Docker compose 文件之外, 还需要替换下面文件中对应的一些变量。   
[subnet 和 security group]
```
File - ecs-params.yml
```

7. 将 Compose File 部署到 Cluster 中
```
ecs-cli compose --project-name sap-lab-ecs service up --create-log-groups --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```

8. 查看 Cluster 中，正在运行的 container  
[也可以通过该命令输出的 IP ，尝试使用浏览器访问网站]
```
ecs-cli compose --project-name sap-lab-ecs service ps --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```

9. 查看 Container Logs  
[有时没有日志返回，不影响本次实验]
```
ecs-cli logs --task-id a630a12329b94ecea66222758c5a012f --follow --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```

10. 扩展 Cluster 中的 task 数量，如下命令会将，task 增加到 2 个：
```
ecs-cli compose --project-name sap-lab-ecs service scale 2 --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```
确认 cluster 有两个 task:
```
ecs-cli compose --project-name sap-lab-ecs service ps --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```

11. 清理实验资源
首先删除 ecs service
```
ecs-cli compose --project-name sap-lab-ecs service down --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```
然后，停掉 cluster
```
ecs-cli down --force --cluster-config sap-lab-ecs --ecs-profile sap-lab-ecs-profile
```
删除 IAM Role
```
SapLabEcsTaskExecutionRole
```
Terminate EC2 instance
