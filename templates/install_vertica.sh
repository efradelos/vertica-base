#!/bin/bash

chown -R ${user} /tmp/deploy

localhost=`curl http://169.254.169.254/latest/meta-data/hostname`

cat << EOF | su - ${user}
  ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

  %{ for addr in hosts }
  ssh-keyscan ${addr} >> ~/.ssh/known_hosts
  %{ endfor }

  %{ for addr in hosts }
  scp -i /tmp/deploy/key -r ~/.ssh ${addr}:.
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

rm -r /tmp/deploy
