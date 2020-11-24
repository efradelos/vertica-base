#!/bin/bash
cat << EOF2 | su - ${user}
  ssh -T ${ip_addrs[0]} << EOF
    sudo /opt/vertica/sbin/install_vertica -s ${ join(",", ip_addrs) } -Y -T -i ~${user}/.ssh/id_rsa
EOF
EOF2



