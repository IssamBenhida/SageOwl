echo "Running ..."

service amazon-cloudwatch-agent stop

docker-compose up -d && tflocal init && tflocal plan && tflocal apply --auto-approve && rm index.zip

ansible-playbook -i inventory.ini ansible.yml -vv