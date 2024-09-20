<p align="center">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/Amazon%20Web%20Services-v5.1.2%20-gray?style=flat&logo=amazonwebservices&labelColor=orange" alt="shield">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/ansible%20playbook-v2.17.1%20-gray?style=flat&logo=ansible&logoColor=black&labelColor=white" alt="shield">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/HashiCorp%20Terraform-v5.1.2%20-gray?style=flat&logo=terraform&logoColor=white&labelColor=purple" alt="shield">
</p>

<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/repo/blob/main/cloudwatch.gif?raw=true">


<p align="center">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="linkedin">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/gmail-red?style=for-the-badge&logo=Gmail&logoColor=white" alt="mail">
</p>

# SkyWatch: Your AWS-Powered Serverless SIEM

Effortlessly monitor and protect your cloud and on-premises environments.

## Features

- **Highly Available**: Always on, always ready.
- **Scalable**: Adapt to your needs without limits.
- **One-Touch Deployment**: Get started in seconds.
- **Cost-Free Local Testing**: Experiment without the expenses.




























### <u>Commands</u>:


Prerequisites:
```bash
pip install awscli-local
pip install terraform-local
```

Creating a lambda function:
```bash
awslocal iam create-role --role-name LambdaSESRole --assume-role-policy-document file://trust-policy.json
```
```bash
zip index.zip index.py
```
```bash
awslocal lambda create-function --function-name mylambda --zip-file fileb://index.zip --handler index.handler --runtime python3.7 --role arn:aws:iam::000000000000:role/LambdaSESRole
```
Invoking a lambda function:
```bash
awslocal lambda invoke --function-name mylambda output.txt
``` 

installing cloudwatch agent service
```bash
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m onPremise -c file:cwa-config.json.j2 -s
```
start cloudwatch agent
```bash
service amazon-cloudwatch-agent start 
```
provoke it
```bash
echo "Test log entry" >> /var/log/syslog
```
