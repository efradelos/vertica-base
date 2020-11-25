#!/bin/bash
# until [[ -f /tmp/auth_ready ]]; do
#   sleep 1
# done

# if [[ -f /tmp/vertica.conf ]]; then
#   sleep 60
#   cat << EOF | su - dbadmin
#     sudo /opt/vertica/sbin/install_vertica -z /tmp/vertica.conf
#     /opt/vertica/bin/admintools -t create_db \
#       -d ${db} \
#       -p ${password} \
#       -s ${ join(",", hosts) } \
#       --shard-count=${shard_count} \
#       --communal-storage-location=${communal_storage} \
#       --depot-path=${depot_path} \
#       -x /tmp/auth_params.conf
# EOF
# fi

#  rm /tmp/vertica.conf
# rm /tmp/auth_params.conf
