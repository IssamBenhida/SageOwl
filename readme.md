<p align="center">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/Amazon%20Web%20Services-v5.0%20-gray?style=flat&logo=amazonwebservices&labelColor=orange" alt="shield">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/ansible%20playbook-v2.17.1%20-gray?style=flat&logo=ansible&logoColor=black&labelColor=white" alt="shield">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/HashiCorp%20Terraform-v1.6.0%20-gray?style=flat&logo=terraform&logoColor=white&labelColor=purple" alt="shield">
</p>
<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/issambenhida/sageowl/blob/main/assets/images/image00.gif?raw=true" height="60%" width="60%" alt="">
</p>
<p align="center">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="linkedin">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/gmail-red?style=for-the-badge&logo=Gmail&logoColor=white" alt="mail">
<a target="_blank" href=""></a><img src="https://img.shields.io/badge/Twitter-black?style=for-the-badge&logo=x&logoColor=white" alt="mail">
</p>

<h1 align="center">&nbsp;&nbsp;&nbsp; :cloud: SageOwl</h1>

<h3 align="center">&nbsp;&nbsp;&nbsp;A Powerful, AWS-Powered Serverless SIEM</h3>

> <h6 align="center">&nbsp;&nbsp;&nbsp;Effortlessly monitor and protect your on-premises and cloud environments.</h6>

<br>

<!-- TABLE OF CONTENTS -->
<details>
  <summary><h2>Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#Overview">Overview</a>
      <ul>
        <li><a href="#Features">Features</a></li>
      </ul>
    </li>
    <li>
      <a href="#Architecture">Architecture</a>
      <ul>
        <li><a href="#aws-architecture-diagram">AWS Architecture Diagram</a></li>
      </ul>
      <ul>
        <li><a href="#disaster-recovery-plan">Disaster Recovery Plan</a></li>
      </ul>
    </li>
    <li><a href="#Environments">Environments</a></li>
    <ul>
        <li><a href="#Development">Development</a></li></li>
        <li><a href="#Staging">Staging</a></li></li>
    </ul>
    <li><a href="#cicd-with-jenkins">CI/CD With Jenkins</a></li>
  </ol>
</details>


![-----------------------------------------------------](https://github.com/IssamBenhida/sageowl/blob/main/assets/images/rainbow.png?raw=true)

## Overview

**SageOwl** is a robust Serverless Security Information and Event Management (SIEM) solution powered by AWS. Designed to seamlessly monitor and protect both on-premises and cloud environments.

> [!IMPORTANT]
> This project is designed to be flexible and customizable,
> feel free to modify the architecture or code to suit your specific requirements.
> If you appreciate this work, please leave a star :star:.

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/issambenhida/sageowl/blob/main/assets/images/image06.png?raw=true" height="95%" width="95%" alt="">
</p>

<br>

This snapshot is taken from with opensearch dashboard.

### Features:

The features of this project are numerous, including user-friendly monitoring, alerting, and incident response, with support for various log types and industry compliance. It also offers advanced analytics, data enrichment, and integration with security tools.

| Feature               | Description                                                                  |
|-----------------------|------------------------------------------------------------------------------|
| ⚡ One-Touch Deployment| Deploy instantly with minimal effort, no complex setup, and quick start time. |
| 🟢 Highly Available   | Always operational, offering continuous uptime, reliability, and readiness.   |
| 💰 Free Testing       | Experiment freely with no upfront costs, allowing risk-free trial and error.  |
| ⚖️ Scalable           | Seamlessly grow and expand without limitations, handling increasing demands.  |
| 🏰 Durable            | Built to last through harsh conditions, heavy workloads, and long-term use.   |

![-----------------------------------------------------](https://github.com/IssamBenhida/sageowl/blob/main/assets/images/rainbow.png?raw=true)

## Architecture

This project focuses on building a scalable, serverless SIEM solution on AWS, leveraging CloudWatch Agents, Kinesis Firehose, Lambda, SNS, OpenSearch, and Elastic Load Balancing. 

#### AWS Architecture Diagram

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/issambenhida/sageowl/blob/main/assets/images/image02.svg?raw=true" height="95%" width="95%" alt="">
</p>

<br>

The platform is designed to provide real-time log analysis, threat detection, and high availability to ensure a robust and efficient security monitoring system.

#### Disaster Recovery Plan
Sage owl project employs a cost-effective **backup and restore** strategy as part of its disaster recovery plan.

+ **Recovery Point Objective (RPO)**:
This project established clear recovery goals
  to ensure robust data protection and quick recovery from potential disruptions.
  The RPO is calculated between **10 and 15 minutes** allowing for minimal data loss in the event of a failure.
+ **Recovery Time Objective (RTO)**:
Simultaneously, the RTO is calculated between **15 and 30 minutes**, ensuring that the system can be restored and operational within this timeframe. 

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/issambenhida/sageowl/blob/main/assets/images/image03.png?raw=true" alt="">
</p>

> [!TIP]
> Different data sets may have varying levels of criticality, and tailoring the Recovery Point Objective and Recovery Time Objective to reflect this can enhance the overall effectiveness of the disaster recovery plan.

![-----------------------------------------------------](https://github.com/IssamBenhida/sageowl/blob/main/assets/images/rainbow.png?raw=true)

## Environments
This project is structured into three distinct environments: **development**, **staging**, and **production**. Each environment is configured to support specific stages of the development lifecycle, allowing for efficient testing and deployment processes while ensuring that changes can be validated before reaching the production stage.

#### Development
In the development environment, we leverage <a href="https://www.localstack.cloud/">LocalStack</a> to simulate AWS services, providing a risk-free testing environment at no cost :moneybag:.

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/sageowl/blob/main/assets/images/image01.svg?raw=true" height="95%" width="95%" alt="">
</p>

<br>

It is also possible to ensure the smooth integration and maintenance of local AWS services by using **tflocal** for Terraform resource deployment and **awslocal** for LocalStack interaction.

LocalStack dashboard is a great option as well.

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/sageowl/blob/main/assets/images/image04.png?raw=true" height="95%" width="95%" alt="">
</p>

<br>

This should also make our testing process much faster, easier and risk-free.

#### Staging


![-----------------------------------------------------](https://github.com/IssamBenhida/sageowl/blob/main/assets/images/rainbow.png?raw=true)

## CI/CD With Jenkins

The Continuous Integration and Continuous Deployment (CI/CD) pipeline for the Sage Owl project automates the build, testing, and deployment processes
for the three environments to ensure code quality and accelerate delivery.

#### Development

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/IssamBenhida/sageowl/blob/main/assets/images/image05.svg?raw=true" height="95%" width="95%" alt="">
</p>

<br>

![-----------------------------------------------------](https://github.com/IssamBenhida/sageowl/blob/main/assets/images/rainbow.png?raw=true)

## Deployment       
<div align="right">
  <a href="#table-of-contents"> ⬆️ Back to top </a>
</div>

This project can be deployed across multiple environments using Terraform and Ansible.
Follow the steps below to deploy the Sage Owl solution.

#### Prerequisites
Ensure the following tools are installed on your local machine:
- docker and docker compose (for local testing)
- terraform
- ansible

#### Deploying Locally

1. Clone the Repository:

```bash
git clone https://github.com/IssamBenhida/SageOwl.git
cd SageOwl
```

2. Deploy the docker containers:
```bash
docker-compose up -d
```

3. Initialize Terraform:
```bash
cd environments/dev
tflocal init
```

4. Apply Terraform Configuration:
```bash
tflocal apply --auto-approve
```

5. Set Up CloudWatch Agent and Logstash Agent with Ansible:
```bash
ansible-playbook -i ansible/inventory.ini ansible/ansible.yml -v 
```


<!-- 
## Commands

Prerequisites:

```bash
pip install awscli-local
pip install terraform-local
```

!>