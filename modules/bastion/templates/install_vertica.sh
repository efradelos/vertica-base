#!/bin/bash
aws_config=`cat ./aws.conf`

ssh ${hosts[0]} bash << EOF
  sudo /opt/vertica/sbin/install_vertica \
    --accept-eula \
    --hosts ${ join(",", hosts) } \
    --data-dir ${data_dir} \
    --temp-dir ${temp_dir} \
    --dba-user ${user} \
    --ssh-identity /home/${user}/.ssh/id_rsa \
    --license ${license}

  echo "$aws_config" > aws.conf
  /opt/vertica/bin/admintools \
    --tool create_db \
    --database ${database} \
    --password ${password} \
    --hosts ${ join(",", hosts) } \
    --shard-count ${shard_count} \
    --communal-storage-location ${communal_storage} \
    --communal-storage-params aws.conf \
    --depot-path ${depot_path}

  rm aws.conf
EOF
