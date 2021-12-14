## Done
- vpc (routes, sg, nacl, subnets, IGW)
- ec2
- NAT GW (eip)
- jump box
- user_data
- alb
- ASG

## ToDo
- SG for jump box
- web domain (GoDaddy WeChat login)
- ACM
- Route 53 ?


## Manual Deploy 

### VPC
1. 创建 VPC (10.0.0.0/16)
2. 创建 公有子网 
    - 10.0.1.0/24
    - 10.0.2.0/24
3. Enable auto-assign public IPv4 address for public subnet
4. 创建 私有子网
    - 10.0.3.0/24
    - 10.0.4.0/24
5. 添加 IGW， 关联到新创建的 VPC 上
6. 新建 public 路由表，关联到公有子网上
7. 为 public 路由表天剑一条到 IGW 的路由
8. 确认公有子网 NACL 配置 (全部允许)
9. 在 公有子网 中创建 ec2 测试访问
10. 测试 ec2 外网连接 - ping www.google.com

### NAT Gateway
1. 在公有子网 1 中，创建 NAT 网关 (注意此处会缠身费用，1 元人民币左右)
2. 更新私有子网路由表，从私有子网发出的公网访问请求，走 NAT 网关

### ASG + ALB
1. 创建一个 安全组 允许所有进站，出站流量 (lab1-instance) [实际工作不推荐，建议遵循最小权限原则]
2. 创建 2 个 launch template (EC2 console) (1 个私有子网 1 个 launch template) [注意 user data 要配置好]
3. 创建 2 个 ASG (1 个私有子网 1 个 ASG) [此处可以顺手配置 ALB 及 target group]

### 测试
访问 ALB endpoint domain，观察流量分发状况

### 问题总结
实验视频中，我如下几点没有做好：
- 应该提前建好一个 SG 允许所有流量，给后续的 launch template 和 ALB 使用 
- 创建 launch template 时，应该把 user data 配置好

- 虽然 launch template 可以再行修改，增加 user data，但是因为 template version 更新，ASG 要随之更新 template version
- 没有提前建好一个 SG 允许所有流量，导致后期花了很多时间 (视频 28 到 45 分钟) 找原因

### 特别提醒
实验结束后，勿忘删除所有资源，尤其是 NAT GW 和 ASG， Elastic IP