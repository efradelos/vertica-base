#!/bin/bash

chown -R ${user} /tmp/deploy

cat << EOF | su - ${user}
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

    %{ for addr in hosts }
    ssh-keyscan ${addr} >> ~/.ssh/known_hosts
    %{ endfor }

    %{ for addr in hosts }
    scp -i /tmp/deploy/key -r ~/.ssh ${addr}:.
    %{ endfor }
EOF

rm /tmp/deploy/key
 