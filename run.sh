echo "Running ..."

truncate -s 0 /var/log/sageowl/main.log
truncate -s 0 /var/log/nginx/access.log

systemctl stop amazon-cloudwatch-agent

docker-compose up -d && tflocal apply --auto-approve && rm index.zip

# ansible-playbook -i ../../ansible/inventory.ini ../../ansible/ansible.yml


# check for errors
# rsyslogd -f /etc/rsyslog.conf -N1

# /etc/logstash/conf.d/logstash.conf

# timestamp=$(($(date +'%s * 1000 + %-N / 1000000')))
# awslocal logs put-log-events --log-group-name localstack-log-group --log-stream-name local-instance --log-events "[{\"timestamp\": ${timestamp} , \"message\": \"hello from cloudwatch\"}]"

#  internal_user_database_enabled if true firehose put logs fails but dashboard auth succeed

# inside localstack
# !!! docker exec -it localstack echo "plugins.security.disabled: true" >> /var/lib/localstack/lib/opensearch/OpenSearch_2.11/config/opensearch.yml

# docker exec -it sendnow-opensearch-dashboard-1 ./usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin remove securityDashboards
# docker exec -it sendnow-opensearch-dashboard-1 sed -i '/^opensearch_security*/d' /usr/share/opensearch-dashboards/config/opensearch_dashboards.yml