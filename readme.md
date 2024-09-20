


<p align="center">
<a target="_blank" href="https://search.maven.org/artifact/com.webencyclop.core/mftool-java"><img src="https://img.shields.io/maven-central/v/com.webencyclop.core/mftool-java.svg?label=Maven%20Central"/></a> 
<a target="_blank" href="https://www.codacy.com/gh/ankitwasankar/mftool-java/dashboard?utm_source=github.com&utm_medium=referral&utm_content=ankitwasankar/mftool-java&utm_campaign=Badge_Coverage"><img src="https://app.codacy.com/project/badge/Coverage/0054db87ea0f426599c3a30b39291388" /></a>
<a href="https://www.codacy.com/gh/ankitwasankar/mftool-java/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ankitwasankar/mftool-java&amp;utm_campaign=Badge_Grade"><img src="https://app.codacy.com/project/badge/Grade/0054db87ea0f426599c3a30b39291388"/></a>
<a target="_blank" href="https://github.com/ankitwasankar/mftool-java/blob/master/license.md"><img src="https://camo.githubusercontent.com/8298ac0a88a52618cd97ba4cba6f34f63dd224a22031f283b0fec41a892c82cf/68747470733a2f2f696d672e736869656c64732e696f2f707970692f6c2f73656c656e69756d2d776972652e737667" /></a>
&nbsp <a target="_blank" href="https://www.linkedin.com/in/ankitwasankar/"><img height="20" src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" /></a>
</p>
<p align="center">
  This repository contains the <strong>MF TOOL - JAVA</strong> source code.
  MF TOOL - JAVA is a Java library developed to ease the process of working with Indian Mutual Funds. It's powerful, actively maintained and easy to use.
</p>

![alt text](https://github.com/IssamBenhida/repo/blob/main/cloudwatch.gif?raw=true)
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
