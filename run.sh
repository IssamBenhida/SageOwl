echo "Running ..."

systemctl stop nginx && systemctl stop logstash
systemctl stop amazon-cloudwatch-agent

docker-compose up -d && tflocal apply --auto-approve && rm index.zip

systemctl start nginx && systemctl start logstash
systemctl start amazon-cloudwatch-agent

cd ../../dashboard && docker-compose up -d && cd environments/dev || exit

# /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.d/file_amazon-cloudwatch-agent.json
# /etc/logstash/conf.d/logstash.conf

# ansible-playbook -i inventory.ini ansible.yml -vv
# timestamp=$(($(date +'%s * 1000 + %-N / 1000000')))
# awslocal logs put-log-events --log-group-name localstack-log-group --log-stream-name local-instance --log-events "[{\"timestamp\": ${timestamp} , \"message\": \"hello from cloudwatch\"}]"

#  internal_user_database_enabled if true firehose put logs fails but dashboard auth succeed

# inside localstack
# !!! docker exec -it localstack echo "plugins.security.disabled: true" >> /var/lib/localstack/lib/opensearch/OpenSearch_2.11/config/opensearch.yml

# docker exec -it sendnow-opensearch-dashboard-1 ./usr/share/opensearch-dashboards/bin/opensearch-dashboards-plugin remove securityDashboards
# docker exec -it sendnow-opensearch-dashboard-1 sed -i '/^opensearch_security*/d' /usr/share/opensearch-dashboards/config/opensearch_dashboards.yml