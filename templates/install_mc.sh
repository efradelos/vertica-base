#!/bin/bash

echo 'Installing Updates'
yum update -y
yum install jq -y

echo 'Waiting for cluster to start.'
while ! nc -z ${host} 5433; do 
    echo -n '.'
    sleep 2
done

echo ''


localhost=`curl http://169.254.169.254/latest/meta-data/hostname`
region=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
az=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .availabilityZone`

/var/opt/vconsole/install_mc.sh

keyfile=$(mktemp -u)

ssh-keygen -t rsa -f $keyfile  -q -N ""
(sleep 60; rm -f $keyfile $keyfile.pub)&

aws ec2-instance-connect send-ssh-public-key \
  --instance-id ${host_id} \
  --region $region \
  --availability-zone $az \
  --instance-os-user ${db_user} \
  --ssh-public-key file://$keyfile.pub

ssh-keyscan ${host} >> ~/.ssh/known_hosts
scp -i $keyfile -r ${db_user}@${host}:.ssh ~${db_user}/.


echo 'cloud.authentication=IAM' >> /opt/vconsole/config/console.properties
echo 'provisioning.service.enabled=true' >> /opt/vconsole/config/console.properties

(cd /var/opt/vconsole; ./mc_config.sh '${user}' '${password}' '${host}' '${db_name}' '${db_user}' '${db_password}')
