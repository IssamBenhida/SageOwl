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
  </ol>
</details>


![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)

## Overview

**SageOwl** is a robust Serverless Security Information and Event Management (SIEM) solution powered by AWS. Designed to seamlessly monitor and protect both on-premises and cloud environments.

> [!IMPORTANT]
> This project is designed to be flexible and customizable. Feel free to modify the architecture or code to suit your specific requirements. If you appreciate this work, please leave a star :star:.

### Features:

The features of this project are numerous, including user-friendly monitoring, alerting, and incident response, with support for various log types and industry compliance. It also offers advanced analytics, data enrichment, and integration with security tools.

| Feature               | Description                                                                  |
|-----------------------|------------------------------------------------------------------------------|
| ⚡ One-Touch Deployment| Deploy instantly with minimal effort, no complex setup, and quick start time. |
| 🟢 Highly Available   | Always operational, offering continuous uptime, reliability, and readiness.   |
| 💰 Free Testing       | Experiment freely with no upfront costs, allowing risk-free trial and error.  |
| ⚖️ Scalable           | Seamlessly grow and expand without limitations, handling increasing demands.  |
| 🏰 Durable            | Built to last through harsh conditions, heavy workloads, and long-term use.   |

![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)

## Architecture

This project focuses on building a scalable, serverless SIEM solution on AWS, leveraging CloudWatch Agents, Kinesis Firehose, Lambda, SNS, OpenSearch, and Elastic Load Balancing. 

#### AWS Architecture Diagram

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/issambenhida/repo/blob/main/arch.drawio.svg?raw=true" alt="">
</p>

The platform is designed to provide real-time log analysis, threat detection, and high availability to ensure a robust and efficient security monitoring system.

#### Disaster Recovery Plan
Sage owl project employs a cost-effective **backup and restore** strategy as part of its disaster recovery plan.

+ **Recovery Point Objective (RPO)**:
This project established clear recovery objectives to ensure robust data protection and quick recovery from potential disruptions. The RPO is calculated between 10 to 15 minutes allowing for minimal data loss in the event of a failure.
+ **Recovery Time Objective (RTO)**:
Simultaneously, the RTO is calculated between 15 to 30 minutes, ensuring that the system can be restored and operational within this timeframe. 

<br>

<p align="center">
<a target="_blank" href=""></a><img src="https://github.com/issambenhida/sageowl/blob/main/assets/images/disaster.png?raw=true" alt="">
</p>

[!NOTE]
- It is highly recommended to periodically review and adjust the recovery objectives based on the importance of the data being processed and stored. Different data sets may have varying levels of criticality, and tailoring the Recovery Point Objective (RPO) and Recovery Time Objective (RTO) to reflect this can enhance the overall effectiveness of the disaster recovery plan.

![-----------------------------------------------------](https://github.com/IssamBenhida/repo/blob/main/rainbow.png?raw=true)

## Environments

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