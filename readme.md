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

<h3 align="center">&nbsp;&nbsp;&nbsp;A Powerful, AWS-Powered Serverless SIEM</h3>

> <h6 align="center">&nbsp;&nbsp;&nbsp;Effortlessly monitor and protect your on-premises and cloud environments.</h6>

<br>

+ :european_castle: Durable: Built to last, even in the harshest conditions.
+ :zap: One-Touch Deployment: Get started in seconds.<br>
+ :moneybag: Free Testing: Experiment without the expenses.<br>
+ :balance_scale: Scalable: Adapt to your needs without limits.<br>
+ :green_circle: Highly Available: Always on, always ready.<br>

<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary><h2>Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#Overview">Overview</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#Architecture">Architecture</a>
      <ul>
        <li><a href="#AWS architecture diagram">AWS architecture diagram</a></li>
        <li><a href="#Development Strategy">Development Strategy</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>


![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)

## Overview

SageOwl is a robust Serverless Security Information and Event Management (SIEM) solution powered by AWS. Designed to seamlessly monitor and protect both on-premises and cloud environments.

> [!IMPORTANT]
> The project is open-source, allowing for customization and adaptation. Your contributions and feedback are valuable. Please show your support by leaving a star. 

+ **User Experience**: User-friendly interface for efficient monitoring, alerting, and incident response
+ **Log Types**: System, web application, network, security, and aws cloud services logs.
+ **Compliance**: Adherence to GDPR, HIPAA, and other industry standards
+ **Analytics**: Anomaly detection, event correlation, threat identification
+ **Enrichment**: Contextual data enrichment for enhanced analysis
+ **Scalability**: Seamless scaling to accommodate increasing workloads
+ **Integration:** Integration with existing security tools

![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)

## Architecture

This project aims to develop a scalable, serverless SIEM solution on AWS. By utilizing CloudWatch Agents, Kinesis Firehose, Lambda, SNS, and OpenSearch, we'll create a robust platform for real-time log analysis and threat detection. A comprehensive backup and disaster recovery plan will ensure data integrity and resilience.

#### AWS Architecture Diagram

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/repo/blob/main/arch.drawio.svg?raw=true" alt="">
</p>

### development strategy

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/repo/blob/main/dev.svg?raw=true" alt="">
</p>

![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)
## Commands

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
