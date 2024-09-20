<p align="center">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/Amazon%20Web%20Services-v5.1.2%20-gray?style=flat&logo=amazonwebservices&labelColor=orange" alt="shield">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/ansible%20playbook-v2.17.1%20-gray?style=flat&logo=ansible&logoColor=black&labelColor=white" alt="shield">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/HashiCorp%20Terraform-v5.1.2%20-gray?style=flat&logo=terraform&logoColor=white&labelColor=purple" alt="shield">
</p>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/repo/blob/main/cloudwatch.gif?raw=true" alt="">
</p>

<p align="center">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="linkedin">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/gmail-red?style=for-the-badge&logo=Gmail&logoColor=white" alt="mail">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/Twitter-black?style=for-the-badge&logo=x&logoColor=white" alt="mail">
</p>

<h1 align="center">&nbsp;&nbsp;&nbsp; :owl: SageOwl</h1>

<h3 align="center">A Powerful, AWS-Powered Serverless SIEM</h3>

> <h6 align="center">Effortlessly monitor and protect your on-premises and cloud environments.</h6>

> [!TIP]
> :zap: **One-Touch Deployment**: Get started in seconds.<br>
> **Highly Available**: Always on, always ready.<br>
> :balance_scale: **Scalable**: Adapt to your needs without limits.<br>
> :moneybag: **Free Testing**: Experiment without the expenses.

![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)

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
