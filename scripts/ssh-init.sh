#!/bin/bash
chown ${user} /tmp/auth_params.conf
chown ${user} /tmp/vertica.conf

cat << EOF | su - ${user}
    chmod 600 ~/key
    ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa -q -N ""
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

    %{ for addr in hosts }
    ssh-keyscan ${addr} >> ~/.ssh/known_hosts
    %{ endfor }

    %{ for addr in hosts }
    scp -i ~/key -r ~/.ssh ${addr}:.
    %{ endfor }

    touch auth_ready;

    scp -i ~/key /tmp/auth_params.conf ${hosts[0]}:/tmp/auth_params.conf
    scp -i ~/key /tmp/vertica.conf ${hosts[0]}:/tmp/vertica.conf

    scp -i ~/key auth_ready ${hosts[0]}:/tmp/auth_ready
    scp -i ~/key auth_ready ${hosts[1]}:/tmp/auth_ready
    scp -i ~/key auth_ready ${hosts[2]}:/tmp/auth_ready

#    rm /tmp/auth_params.conf
#    rm /tmp/vertica.conf
EOF
