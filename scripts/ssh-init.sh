#!/bin/bash
cat << EOF | su - ${user}
    chmod 600 ~/key
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

    %{ for addr in ip_addrs }
    ssh-keyscan ${addr} >> ~/.ssh/known_hosts
    %{ endfor }

    %{ for addr in ip_addrs }
    scp -i ~/key -r ~/.ssh ${addr}:.
    %{ endfor }
EOF
