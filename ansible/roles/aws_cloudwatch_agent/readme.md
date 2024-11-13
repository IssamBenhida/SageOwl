Role Name
=========

aws_cloudwatch_agent

This role installs and configures the AWS CloudWatch Agent on an on-premises Linux Debian-based server, allowing for the monitoring
of system metrics and logs.

Requirements
------------

- Ansible 2.17 or higher.
- Python must be installed on the target server.

Role Variables
--------------

- `application_log_file_path`: The path to the application log file to be monitored.
- `log_group_name`: The name of the CloudWatch log group.
- `log_stream_name`: The name of the log stream for the instance.

Dependencies
------------

- None. This role does not have external dependencies.

Example Playbook
----------------

Here’s an example of how to use this role in a playbook:

```yaml
- hosts: servers
  become: yes
  roles:
    - role: aws_cloudwatch_agent
      application_log_file_path: "/var/logs/main.log"
      log_group_name: "log-group-example"
      log_stream_name: "log-steam-exemple"
```