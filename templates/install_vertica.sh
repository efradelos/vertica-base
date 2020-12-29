#!/bin/bash

localhost=`curl http://169.254.169.254/latest/meta-data/hostname`
region=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
az=`curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .availabilityZone`

cat << EOF | su - ${user}
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

  %{ for idx, host in hosts }
  ssh-keyscan ${host} >> ~/.ssh/known_hosts
  
  ssh-keygen -t rsa -f ${host}  -q -N ""

  (sleep 60; rm ${host} ${host}.pub)&

  aws ec2-instance-connect send-ssh-public-key \
      --instance-id ${instance_ids[idx]} \
      --region $region \
      --availability-zone $az \
      --instance-os-user ${user} \
      --ssh-public-key file://${host}.pub

  scp -i ${host} -r ~/.ssh ${host}:.
  %{ endfor }

  sudo /opt/vertica/sbin/install_vertica \
    --accept-eula \
    --hosts $localhost,${ join(",", hosts) } \
    --data-dir ${data_dir} \
    --dba-user ${user} \
    --ssh-identity /home/${user}/.ssh/id_rsa \
    --license ${license}

  /opt/vertica/bin/admintools \
    --tool create_db \
    --database "${database}" \
    --password "${password}" \
    --hosts $localhost,${ join(",", hosts) } \
    --shard-count ${shard_count} \
    --communal-storage-location "${communal_storage}" \
    --depot-path "${depot_path}"
EOF
