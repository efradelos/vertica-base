#!/bin/bash

chown -R ${user} /tmp/deploy

aws_config=`cat /tmp/deploy/aws.conf`

cat << EOF | su - ${user}
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

  %{ for addr in hosts }
  ssh-keyscan ${addr} >> ~/.ssh/known_hosts
  %{ endfor }

  %{ for addr in hosts }
  scp -i /tmp/deploy/key -r ~/.ssh ${addr}:.
  %{ endfor }

  ssh ${hosts[0]} bash << SSHX
    sudo /opt/vertica/sbin/install_vertica \
      --accept-eula \
      --hosts ${ join(",", hosts) } \
      --data-dir ${data_dir} \
      --dba-user ${user} \
      --ssh-identity /home/${user}/.ssh/id_rsa \
      --license ${license}

    echo "$aws_config" > aws.conf
    /opt/vertica/bin/admintools \
      --tool create_db \
      --database "${database}" \
      --password "${password}" \
      --hosts ${ join(",", hosts) } \
      --shard-count ${shard_count} \
      --communal-storage-location "${communal_storage}" \
      --communal-storage-params aws.conf \
      --depot-path "${depot_path}"

    rm aws.conf
SSHX
EOF

# rm -r /tmp/deploy
